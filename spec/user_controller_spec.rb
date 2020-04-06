require 'rails_helper'

RSpec.describe "TestUserControllerAPI", :type => :request do

  describe "Post #signup" do

    it "should return error = false and msg = succss" do

      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur@hackerrank.com",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 200.to_s
      expect(res["error"]).to eq false
      expect(res["msg"]).to eq "success"
    end

    it "should return error = true and msg = password too short" do
      
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur@hackerrank.com",
        :password => "1234"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["password"]).to eq ["is too short (minimum is 6 characters)"]
    end

    it "should return error = true and msg = email is already taken" do

      User.create(:name => "Harendra Chhekur", :email => "harendra.chhekur@hackerrank.com", :password => "123456")
      
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur@hackerrank.com",
        :password => "123456"
      }
      
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["email"]).to eq ["has already been taken"]
    end

    it "should return error = true and msg = invalid email" do
      
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur#hackerrank.com",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["email"]).to eq ["is invalid"]
    end


    it "should return error = true and msg = email required" do
      
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["email"]).to eq ["can't be blank", "is invalid"]
    end

    it "should return error = true and msg = name required" do
        
      post '/api/signup', :params => {
        :email => "harendra.chhekur@hackerrank.com",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["name"]).to eq ["can't be blank"]
    end

    it "should return error = true and msg = password required" do
        
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur#hackerrank.com"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]["password"]).to eq ["can't be blank", "can't be blank", "is too short (minimum is 6 characters)"]
    end
  end

  describe "Post #login" do

    Rails.application.config.jwt_key = "3s465d76f8t7gyoubinp".to_s

    before do
      post '/api/signup', :params => {
        :name => "Harendra Chhekur",
        :email => "harendra.chhekur@hackerrank.com",
        :password => "123456"
      }
    end

    it "should return error = false msg = success" do

      post '/api/login', :params => {
        :email => "harendra.chhekur@hackerrank.com",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 200.to_s
      expect(res["error"]).to eq false
      expect(res["msg"]).to eq "success"
    end

    it "should return error = true msg = invalid details" do

      post '/api/login', :params => {
        :email => "harendra.chhekur+test@hackerrank.com",
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]).to eq "invalid details"
    end

    it "should return error = true msg = missing parameters" do

      post '/api/login', :params => {
        :password => "123456"
      }

      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 400.to_s
      expect(res["error"]).to eq true
      expect(res["msg"]).to eq "missing parameters"
    end
  end
end