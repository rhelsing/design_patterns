class Employee

  def initialize( name, title, salary )
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

end

fred = Employee.new('Fred', 'Crane Operator', 30000.0)

class Payroll
  def update(changed_employee)
    puts("#{changed_employee.name} just got salary set!")
  end
end

payroll = Payroll.new
fred.add_observer(payroll)
fred.salary=35000.0

class TaxMan
  def update(changed_employee)
    puts("Send #{changed_employee.name} a new tax bill!")
  end
end

tax_man = TaxMan.new
fred.add_observer(tax_man)
fred.salary=90000.0
