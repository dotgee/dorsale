require_dependency dorsale_file

# Auto define all policies to true in dummy
Dorsale::ApplicationPolicy.class_eval do
  def self.define_dummy_policies!
    self::POLICY_METHODS.each do |method|
      define_method(method) { true }
    end
  end
end

# No scopes in dummy
Dorsale::ApplicationPolicy::Scope.class_eval do
  def resolve
    scope.all
  end
end
