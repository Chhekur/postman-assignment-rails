require 'rails_helper'

RSpec.describe CalendarController, :type => :controller do

  describe "Access API without login" do

    it "should return error = true msg = unauthorized access on create-slot" do
      post :create_slot, :params => {}
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 401.to_s
      expect(res["msg"]).to eq "unauthorized access"
    end

    it "should return error = true msg = unauthorized access on book-slot" do
      post :book_slot, :params => {}
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 401.to_s
      expect(res["msg"]).to eq "unauthorized access"
    end

    it "should return error = true msg = unauthorized access on get-slots" do
      get :get_slots, :params => {}
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 401.to_s
      expect(res["msg"]).to eq "unauthorized access"
    end

    it "should return error = true msg = unauthorized access on get-available-slots" do
      get :get_available_slots, :params => {}
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 401.to_s
      expect(res["msg"]).to eq "unauthorized access"
    end

    it "should return error = true msg = unauthorized access on get-booked-slots" do
      get :get_booked_slots, :params => {}
      res = JSON.parse(response.body)
      expect(response.status.to_s).to eq 401.to_s
      expect(res["msg"]).to eq "unauthorized access"
    end
  end

  describe "Access API with login" do

    Rails.application.config.jwt_key = "3s465d76f8t7gyoubinp".to_s

    before do
      user = User.create(:name => "Harendra Chhekur", :email => "harendra.chhekur@hackerrank.com", :password => "123456")
      user.calendar = Calendar.create()

      headers = {
        Authorization: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1ODYyNzQzNTB9.UIZi6JDuDCUO2ClBev5nDKTIp5O-6zsSHWD_R7FzWbE"
      }
      request.headers.merge!(headers)

      post :create_slot, :params => {
        :year => "2020",
        :month => "12",
        :day => "31",
        :start_time => "24",
        :end_time => "1",
        :email => "harendra.chhekur@hackerrank.com"
      }

    end

    describe "Post #create_slot" do

      it "should return error = true msg = success with all parameterss" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "15",
          :start_time => "10",
          :end_time => "11"
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 200.to_s
        expect(res["msg"]).to eq "slot created"
      end

      it "should return error = true msg = missing parameter with missing parameters" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "15"
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "missing parameters"
      end

      it "should return error = true msg = invalid year with invalid year" do
        post :create_slot, :params => {
          :year => "20233",
          :month => "12",
          :day => "15",
          :start_time => "10",
          :end_time => "11"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "invalid year"
      end

      it "should return error = true msg = invalid month with invalid month" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "13",
          :day => "15",
          :start_time => "10",
          :end_time => "11"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "invalid month"
      end

      it "should return error = true msg = invalid day with invalid day" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "33",
          :start_time => "10",
          :end_time => "11"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "invalid day"
      end

      it "should return error = true msg = invalid start time with invalid start_time" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "25",
          :end_time => "11"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "invalid start time"
      end

      it "should return error = true msg = invalid end time with invalid end_time" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "-1"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "invalid end time"
      end

      it "should return error = true msg = already exists end time with exists slot" do
        post :create_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "1"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "slot is alredy there"
      end
    end

    describe "Post #book_slot" do

      it "should return error = false msg = success with all parameters" do
        post :book_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "1",
          :email => "harendra.chhekur@hackerrank.com"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 200.to_s
        expect(res["msg"]).to eq "slot booked"
      end

      it "should return error = true msg = invalid slot with unavailable slot" do
        post :book_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "12",
          :email => "harendra.chhekur@hackerrank.com"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "slot doesn't exists"
      end

      it "should return error = true msg = invalid with invalid user" do
        post :book_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "12",
          :email => "harendra.chhekur+dev@hackerrank.com"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "user doesn't exists"
      end

      it "should return error = true msg = missing parameters with missing parameters" do
        post :book_slot, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :email => "harendra.chhekur@hackerrank.com"
        }
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "missing parameters"
      end
    end

    describe "Post #get_slots" do

      it "should return error = false data = all slots with all parameters" do
        post :get_slots, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :email => "harendra.chhekur@hackerrank.com"
        }

        data = {
          "day_id"=>"1",
          "end_time"=>"1",
          "id"=>1,
          "is_available"=>true,
          "start_time"=>"24",
          "user"=>nil
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 200.to_s
        expect(res["data"]).to match [a_hash_including(data)]
      end

      it "should return error = true data = missing parameters with missing parameters" do
        post :get_slots, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "missing parameters"
      end

      it "should return error = true msg = slot alredy booked with already book slots" do
        params = {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "1",
          :email => "harendra.chhekur@hackerrank.com"
        }
        post :book_slot, :params => params
        post :book_slot, :params => params
        
        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "slot is already booked"
      end
    end

    describe "Post #get_available_slots" do

      it "should return error = false data = all available slots with all parameters" do
        post :get_available_slots, :params => {
          :year => "2020",
          :month => "12",
          :day => "31",
          :email => "harendra.chhekur@hackerrank.com"
        }

        data = {
          "day_id" => "1",
          "end_time" => "1",
          "id" => 1,
          "is_available" => true,
          "start_time" => "24",
          "user"=> nil
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 200.to_s
        expect(res["data"]).to match [a_hash_including(data)]
      end
    end

    describe "Post #get_booked_slots" do

      it "should return error = false data = all booked slots with all parameters" do
        params = {
          :year => "2020",
          :month => "12",
          :day => "31",
          :start_time => "24",
          :end_time => "1",
          :email => "harendra.chhekur@hackerrank.com"
        }
        post :book_slot, :params => params
        post :get_booked_slots, :params => params

        data = {
          "day_id" => "1",
          "end_time" => "1",
          "id" => 1,
          "is_available" => false,
          "start_time" => "24",
          "user" => "1"
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 200.to_s
        expect(res["data"]).to match [a_hash_including(data)] 
      end

      it "should return error = true msg = no slots with no booked slots" do
        post :get_booked_slots, :params => {
          :year => "2020",
          :month => "12",
          :day => "30",
          :start_time => "24",
          :end_time => "1",
          :email => "harendra.chhekur@hackerrank.com"
        }

        res = JSON.parse(response.body)
        expect(response.status.to_s).to eq 400.to_s
        expect(res["msg"]).to eq "no available slots for this date"
      end
    end
  end
end