require "spec_helper"

describe Lita::Handlers::Kidoikoi, lita_handler: true do

  let(:botname) { "Lita" }

  describe "command : split_bill" do
    it { is_expected.to route("#{botname} split_bill @debtor 152 @creditor") }
    it { is_expected.to route("#{botname} split_bill @debtor1 @debtor2 @debtor3 1234567.89 @creditor") }
    it { is_expected.to route("#{botname} split_bill @debtor @debtor 0 @debtor") }

    it { is_expected.not_to route("#{botname} split_bill") }
    it { is_expected.not_to route("#{botname} split_bill @debtor -10 @creditor") }
    it { is_expected.not_to route("#{botname} split_bill debtor 10 creditor") }
    it { is_expected.not_to route("#{botname} split_bill @debtor 10") }
    it { is_expected.not_to route("#{botname} split_bill @debtor 10 @creditor1 @creditor2") }

    describe "when we want to split a 10 euros bill between one debtor and one creditor" do
      let(:message) { "#{botname} split_bill @debtor 10 @creditor" }

      it "sends [@debtor], 10 and @creditor to kidoikoi#split_bill_between" do
        expect_any_instance_of(Kidoikoi).to receive(:split_bill_between).with(["@debtor"], 10, "@creditor")
        send_message(message)
      end

      it "responds a success message" do
        send_message(message)

        expect(replies.last).to eq("A 10.00 euros bill has been successfully split")
      end
    end

    describe "when we want to split a 5.99 euros bill between two debtors and one creditor" do
      let(:message) { "#{botname} split_bill @debtor1 @debtor2 5.99 @creditor" }

      it "sends [@debtor1, @debtor2], 5.99, @creditor to kidoikoi#split_bill_between" do
        expect_any_instance_of(Kidoikoi).to receive(:split_bill_between).with(["@debtor1", "@debtor2"], 5.99, "@creditor")
        send_message(message)
      end

      it "responds a success message" do
        send_message(message)

        expect(replies.last).to eq("A 5.99 euros bill has been successfully split")
      end
    end
  end

  describe "command : resume_debt" do
    it { is_expected.to route( "#{botname} resume_debt @user" ) }

    it { is_expected.not_to route("#{botname} resume_debt") }
    it { is_expected.not_to route("#{botname} resume_debt user") }
    it { is_expected.not_to route("#{botname} resume_debt @user1 @user2") }

    context "when @user have no debt" do
      context "when we want the debts resume of this user" do
        before do
          allow_any_instance_of(Kidoikoi).to receive(:resume_debt).with("@user").and_return({})
        end

        let(:message) { "#{botname} resume_debt @user" }

        it "sends @user to kidoikoi#resume_debt" do
          expect_any_instance_of(Kidoikoi).to receive(:resume_debt).with("@user")

          send_message(message)
        end

        it "display a message saying that this user do not have debts" do
          send_message(message)

          expect(replies.last).to eq( "@user do not have any debt" )
        end
      end
    end
    context "when @user have debts" do
      before do
        allow_any_instance_of(Kidoikoi).to receive(:resume_debt).with("@user").and_return({"@user1" => 10.00, "@user2" => -20.00 })
      end

      context "when we want the debts resume of this user" do
        let(:message) { "#{botname} resume_debt @user" }

        it "displays debts of this user" do
          send_message(message)

          expect(replies.last).to eq("@user credit:\n@user1: 10.00 euros\n@user2: -20.00 euros")
        end
      end
    end
  end

  describe "command : clear_debt" do
    it { is_expected.to route("#{botname} clear_debt @user1 @user2") }

    it { is_expected.not_to route("#{botname} clear_debt") }
    it { is_expected.not_to route("#{botname} clear_debt @user1") }
    it { is_expected.not_to route("#{botname} clear_debt user1 user2") }
    it { is_expected.not_to route("#{botname} clear_debt @user1 @user2 @user3") }

    context "when we want to clear debt between @user1 and @user2" do
      let(:message) {"#{botname} clear_debt @user1 @user2" }

      it "sends @user1 @user2 to kidoikoi#clear_debt_between" do
        expect_any_instance_of(Kidoikoi).to receive(:clear_debt_between).with("@user1", "@user2")

        send_message(message)
      end

      it "responds a success message" do
        send_message(message)

        expect(replies.last).to eq("Debt between @user1 and @user2 has been successfully clear")
      end
    end
  end
end
