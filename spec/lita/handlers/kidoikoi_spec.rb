require "spec_helper"

describe Lita::Handlers::LitaKidoikoi, lita_handler: true do
  let(:botname) {"Lita"}

  it { is_expected.not_to route("#{botname} kidoikoi") }
  it { is_expected.not_to route("#{botname} kidoikoi wrong_command") }

  describe "command : split_bill_between" do
    it { is_expected.not_to route("#{botname} kidoikoi split_bill_between") }
    it { is_expected.not_to route("#{botname} kidoikoi split_bill_between @debtor -10 @creditor") }
    it { is_expected.not_to route("#{botname} kidoikoi split_bill_between debtor 10 creditor") }
    it { is_expected.not_to route("#{botname} kidoikoi split_bill_between @debtor 10") }
    it { is_expected.not_to route("#{botname} kidoikoi split_bill_between @debtor 10 @creditor1 @creditor2") }

    describe "when the message is : <botname> kidoikoi split_bill_between @debtor 10 @creditor" do
      before do
        expect_any_instance_of(Kidoikoi).to receive(:split_bill_between).with(["@debtor"], 10, "@creditor")
      end

      let(:message) {"#{botname} kidoikoi split_bill_between @debtor 10 @creditor"}

      it "sends [@debtor], 10 and @creditor to kidoikoi#split_bill_between" do
        send_message(message)
      end

      it "responds a sucess message" do
        send_message(message)

        expect(replies.size).to eq(1)
        expect(replies.last).to eq("A 10.00 euros bill has been sucessfully split")
      end
    end

    describe "when the message is : lita kidoikoi split_bill_between @debtor1 @debtor2 5.99 @creditor" do
      before do
        expect_any_instance_of(Kidoikoi).to receive(:split_bill_between).with(["@debtor1", "@debtor2"], 5.99, "@creditor")
      end

      let(:message) {"#{botname} kidoikoi split_bill_between @debtor1 @debtor2 5.99 @creditor"}

      it "sends [@debtor1, @debtor2], 5.99, @creditor to kidoikoi#split_bill_between" do
        send_message(message)
      end

      it "responds a sucess message" do
        send_message(message)

        expect(replies.size).to eq(1)
        expect(replies.last).to eq("A 5.99 euros bill has been sucessfully split")
      end
    end
  end

  describe "command : resume_debt" do
    it { is_expected.not_to route("#{botname} kidoikoi resume_debt") }
    it { is_expected.not_to route("#{botname} kidoikoi resume_debt user") }
    it { is_expected.not_to route("#{botname} kidoikoi resume_debt @user1 @user2") }

    context "when User have no debt" do
      context "when the message is : <botname> kidoikoi resume_debt @User" do
        let(:message) {"#{botname} kidoikoi resume_debt @User"}

        it "responds a message" do
          send_message(message)

          expect(replies.size).to eq(1)
          expect(replies.last).to eq("@User do not have any debt")
        end
      end
    end
    context "when User have debts" do
      before do
        allow_any_instance_of(Redis::Namespace).to receive(:get).with("@User").and_return({"@User1" => 10.00, "@User2" => -20.00 })
      end

      context "when the message is : <botname> kidoikoi resume_debt @User" do
        let(:message) {"#{botname} kidoikoi resume_debt @User"}

        it "responds a message" do
          send_message(message)

          expect(replies.size).to eq(1)
          expect(replies.last).to eq("@User credit:\n@User1: 10.00 euros\n@User2: -20.00 euros")
        end
      end
    end
  end

  describe "command : clear_debt_between" do
    it { is_expected.not_to route("#{botname} kidoikoi clear_debt_between") }
    it { is_expected.not_to route("#{botname} kidoikoi clear_debt_between @user1") }
    it { is_expected.not_to route("#{botname} kidoikoi clear_debt_between user1 user2") }
    it { is_expected.not_to route("#{botname} kidoikoi clear_debt_between @user1 @user2 @user3") }

    context "when the message is : <botname> kidoikoi clear_debt @user1 @user2" do
      before do
        expect_any_instance_of(Kidoikoi).to receive(:clear_debt_between).with("@user1", "@user2")
      end

      let(:message) {"#{botname} kidoikoi clear_debt_between @user1 @user2"}

      it "sends @user1 @user2 to kidoikoi#clear_debt_between" do
        send_message(message)
      end

      it "responds a sucess message" do
        send_message(message)

        expect(replies.size).to eq(1)
        expect(replies.last).to eq("Debt between @user1 and @user2 has been sucessfully clear")
      end
    end
  end
end
