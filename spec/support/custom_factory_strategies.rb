class JsonApiStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:attributes_for).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    result = { type: evaluation.object.class.to_s.downcase.pluralize,
               attributes: @strategy.result(evaluation) }

    result.tap do |obj|
      evaluation.notify(:attachment_file, obj)
    end
  end
end
