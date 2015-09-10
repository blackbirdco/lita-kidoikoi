class Kidoikoi
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def split_bill_between(debtors, total_value, creditor)
    remove_all_duplicate_in(debtors, creditor)

    total_people = debtors.length + 1
    amount = calcul_amount(total_value, total_people)

    debtors.each do |debtor|
      add_amount_to_debt_between(debtor, creditor, amount)
    end
  end

  def clear_debt_between(user1, user2)
    delete_debt(user_from: user1, user_to: user2)
    delete_debt(user_from: user2, user_to: user1)
  end

  def debts_of(user)
    debts = database.get(user) || {}
    debts = eval(debts) if debts.is_a? String
    debts
  end

  alias_method :resume_debt, :debts_of

  private

  def remove_all_duplicate_in(debtors, creditor)
    debtors.uniq!
    debtors.delete(creditor)
  end

  def calcul_amount(total_value, total_people)
    (total_value / total_people).round(2)
  end

  def add_amount_to_debt_between(debtor, creditor, amount)
    add_debt(-amount, user_from: debtor, user_to: creditor)
    add_debt(amount, user_from: creditor, user_to: debtor)
  end

  def add_debt(amount, user_from: nil, user_to: nil)
    user_debts = debts_of(user_from)
    user_debts[user_to] = calcul_debt_value(user_debts[user_to], amount)
    database.set(user_from, user_debts)
  end

  def calcul_debt_value(debt_value, amount)
    debt_value ||= 0
    debt_value += amount
  end

  def delete_debt(user_from: nil, user_to: nil)
    user_debts = debts_of(user_from)
    user_debts.delete(user_to)
    database.set(user_from, user_debts)
  end
end
