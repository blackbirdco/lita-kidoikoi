require 'kidoikoi'

module Lita
  module Handlers
    class Kidoikoi < Handler

      # http://rubular.com/r/GfhJLmGQ6T
      route(/^split_bill(\s+@\S+)+\s+\d+[.€]?\d{0,2}\s+@\S+$/,
        :split_bill, command: true,
        help: {
          "split_bill @DEBTOR1 @DEBTOR2 12 @CREDITOR" =>
            "Split a 12 euros bill : @DEBTOR1 and @DEBTOR2 owe now 3 euros to @CREDITOR, in addition of their previous debt"
        }
      )

      def split_bill(response)
        kidoikoi = ::Kidoikoi.new(redis)

        creditor = response.args.last
        value = response.args[-2].to_f
        debtors = response.args[0..-3]

        kidoikoi.split_bill_between(debtors, value, creditor)

        response.reply("A %.2f euros bill has been successfully split" % value)
      end

       # http://rubular.com/r/ZlHye1zlsM
      route(/^clear_debt\s+@\S+\s+\@\S+$/,
        :clear_debt, command: true,
        help: {"clear_debt @USER1 @USER2" => "Clear mutual debt between @USER1 and @USER2."}
      )

      def clear_debt(response)
        kidoikoi = ::Kidoikoi.new(redis)

        kidoikoi.clear_debt_between(response.args.first, response.args.last)

        response.reply "Debt between #{response.args.first} and #{response.args.last} has been successfully clear"
      end

      # http://rubular.com/r/YLVKvUGubl
      route(/^resume_debt\s+@\S+$/,
        :resume_debt, command: true,
        help: { "resume_debt @USER" => "Resume debt of @USER." }
      )

     def resume_debt(response)
        kidoikoi = ::Kidoikoi.new(redis)

        user = response.args.last
        user_debts = kidoikoi.resume_debt(user)

        response.reply formated_debt(user, user_debts)
      end

      private

      def formated_debt(user, user_debts)
        if user_debts.empty?
          "#{user} do not have any debt"
        else
          reply = "#{user} credit:\n"

          user_debts.each do |to_whom, debt|
            reply += "%s: %.2f euros\n" % [to_whom, debt]
          end
          reply.chop
        end
      end
    end

    Lita.register_handler(Kidoikoi)
  end
end
