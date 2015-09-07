require_relative "../../kidoikoi.rb"

module Lita
  module Handlers
    class LitaKidoikoi < Handler

      # Regular expression : http://rubular.com/r/QyRn4c5zne
      route(
        /^kidoikoi (split_bill_between (\@[^\s]+ )+[\d]+.?[\d]{0,2} \@[^\s]+|resume_debt \@[^\s]+|clear_debt_between \@[^\s]+ \@[^\s]+)$/,
        :kidoikoi, command: true, help: {
          "kidoikoi" => "Split bill between coworkers:\n
          Commands:\n
          *kidoikoi split_bill_between*  _@debtor1_ _..._ _value_ _@creditor_\n
          *kidoikoi clear_debt_between* _@user1_ _@user2_ \n
          *kidoikoi resume_debt* _@user1_"
        }
      )

      def kidoikoi response
        kidoikoi = Kidoikoi.new(Redis::Namespace.new(:ns, :redis => Redis.new))
        send(response.args[0], response, kidoikoi)
      end

      private

      def split_bill_between(response, kidoikoi)
        creditor = response.args.last
        value = response.args[- 2].to_f
        debtors = response.args[1..-3]

        kidoikoi.split_bill_between(debtors, value, creditor)

        response.reply ("A %.2f euros bill has been sucessfully split" % value)
      end

      def clear_debt_between (response, kidoikoi)
        kidoikoi.clear_debt_between(response.args[1], response.args[2])

        response.reply "Debt between #{response.args[1]} and #{response.args[2]} has been sucessfully clear"
      end

      def resume_debt (response, kidoikoi)
        user = response.args.last
        user_debts = kidoikoi.resume_debt(user)

        response.reply formated_debt(user, user_debts)
      end

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
    Lita.register_handler(LitaKidoikoi)
  end
end
