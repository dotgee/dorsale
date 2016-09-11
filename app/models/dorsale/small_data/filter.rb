class Dorsale::SmallData::Filter
  def initialize(jar)
    @jar = jar
  end

  def store(filters)
    @jar["filters"] = filters.to_json
  end

  def read
    JSON.parse @jar["filters"].to_s
  rescue JSON::ParserError
    {}
  end

  def get(key)
    read[key.to_s]
  end

  def set(key, value)
    array           = read
    array[key.to_s] = value
    store(array)
  end

  def strategies
    self.class::STRATEGIES
  end

  def apply(query)
    strategies.each do |key, strategy|
      value = get(key)

      next if value.blank?

      query = strategy.apply(query, value)
    end

    return query
  end

  def method_missing(method, *args)
    key = method.to_s

    if strategies.key?(key)
      get(key)
    else
      super
    end
  end
end
