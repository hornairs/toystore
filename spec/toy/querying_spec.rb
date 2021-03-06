require 'helper'

describe Toy::Querying do
  uses_constants 'User', 'Game'

  before do
    User.attribute :name, String
  end

  describe ".get" do
    it "returns document if found" do
      john = User.create(:name => 'John')
      User.get(john.id).name.should == 'John'
    end

    it "returns nil if not found" do
      User.get('1').should be_nil
    end
  end

  describe ".get!" do
    it "returns document if found" do
      john = User.create(:name => 'John')
      User.get!(john.id).name.should == 'John'
    end

    it "raises not found exception if not found" do
      lambda {
        User.get!('1')
      }.should raise_error(Toy::NotFound, 'Could not find document with id: "1"')
    end
  end

  describe ".get_multi" do
    it "returns array of documents" do
      john  = User.create(:name => 'John')
      steve = User.create(:name => 'Steve')
      User.get_multi(john.id, steve.id).should == [john, steve]
    end
  end

  describe ".get_or_new" do
    it "returns found" do
      user = User.create
      User.get_or_new(user.id).should == user
    end

    it "creates new with id set if not found" do
      user = User.get_or_new('foo')
      user.should be_instance_of(User)
      user.id.should == 'foo'
    end
  end

  describe ".get_or_create" do
    it "returns found" do
      user = User.create
      User.get_or_create(user.id).should == user
    end

    it "creates new with id set if not found" do
      user = User.get_or_create('foo')
      user.should be_instance_of(User)
      user.id.should == 'foo'
    end
  end

  describe ".key?" do
    it "returns true if key exists" do
      user = User.create(:name => 'John')
      User.key?(user.id).should be_true
    end

    it "returns false if key does not exist" do
      User.key?('taco:bell:tacos').should be_false
    end
  end

  describe ".has_key?" do
    it "returns true if key exists" do
      user = User.create(:name => 'John')
      User.has_key?(user.id).should be_true
    end

    it "returns false if key does not exist" do
      User.has_key?('taco:bell:tacos').should be_false
    end
  end

  describe ".load" do
    before do
      class Admin < ::User; end
    end

    after do
      Object.send :remove_const, 'Admin' if defined?(Admin)
    end

    context "without type, hash attrs" do
      before do
        @doc = User.load('1', :name => 'John')
      end

      it "returns instance" do
        @doc.should be_instance_of(User)
      end

      it "marks object as persisted" do
        @doc.should be_persisted
      end

      it "decodes the object" do
        @doc.name.should == 'John'
      end
    end

    context "without type, nil attrs" do
      before do
        @doc = User.load('1', nil)
      end

      it "returns instance" do
        @doc.should be_instance_of(User)
      end

      it "marks object as persisted" do
        @doc.should be_persisted
      end

      it "decodes the object" do
        @doc.name.should be_nil
      end
    end

    context "with symbol type" do
      before do
        @doc = User.load('1', :type => 'Admin', :name => 'John')
      end

      it "returns instance of type" do
        @doc.should be_instance_of(Admin)
      end
    end

    context "with string type" do
      before do
        @doc = User.load('1', 'type' => 'Admin', :name => 'John')
      end

      it "returns instance of type" do
        @doc.should be_instance_of(Admin)
      end
    end

    context "for type that doesn't exist" do
      before do
        Object.send :remove_const, 'Admin' if defined?(::Admin)
        @doc = User.load('1', 'type' => 'Admin', :name => 'John')
      end

      it "returns instance of loading class" do
        @doc.should be_instance_of(User)
      end
    end
  end
end
