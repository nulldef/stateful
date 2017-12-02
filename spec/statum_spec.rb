class Car
  include Statum

  attr_accessor :state

  statum :state, initial: :parked do
    state :parked
    state :riding

    event :ride, parked: :riding
    event :stop, riding: :parked
  end
end

RSpec.describe Statum do
  let(:car) { Car.new }

  it "has boolean helper methods" do
    expect(car.parked?).to be_truthy
    expect(car.riding?).to be_falsey
  end

  it "has state methods" do
    expect(car).to respond_to(:parked?)
    expect(car).to respond_to(:riding?)
  end

  it "raises error when state is unknown" do
    expect { car.unknown? }.to raise_error(NoMethodError)
    expect(car).not_to respond_to(:unknown?)
  end

  it "has event methods" do
    expect(car).to respond_to(:ride!)
    expect(car).to respond_to(:stop!)
  end

  it "fires events and changes state" do
    car.ride!
    expect(car.riding?).to be_truthy
  end

  it "raises error when event not exists" do
    expect { car.unknown! }.to raise_error(NoMethodError)
    expect(car).not_to respond_to(:unknown!)
    expect(car).not_to respond_to(:unknown_method)
  end

  it "raises error when 'from state' is not valid" do
    car.state = :riding
    expect { car.ride! }.to raise_error(Statum::ErrorTransitionError)
  end
end