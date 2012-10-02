
class MopedCommandFake

  def initialize(log_statement)
    @log_statement = log_statement
  end

  def log_inspect
    @log_statement
  end
end

class MopedCommandWithCollectionFake

  def initialize(log_statement, collection)
    @log_statement = log_statement
    @collection = collection
  end

  def log_inspect
    @log_statement
  end

  def collection
    @collection
  end
end