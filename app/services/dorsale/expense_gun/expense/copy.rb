class Dorsale::ExpenseGun::Expense::Copy < ::Dorsale::Service
  attr_accessor :expense, :copy

  def initialize(expense)
    @expense = expense
  end

  def call
    @copy = expense.dup

    @copy.user       = nil
    @copy.date       = nil
    @copy.state      = "new"
    @copy.created_at = nil
    @copy.updated_at = nil

    @expense.expense_lines.each do |line|
      line            = line.dup
      line.date       = nil
      line.created_at = nil
      line.updated_at = nil
      @copy.expense_lines << line
    end

    @copy
  end
end
