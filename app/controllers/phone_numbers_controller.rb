class PhoneNumbersController < ApplicationController


  def new
    @phone_number = PhoneNumber.new

    @read_file=File.open("public/twilio_error.txt").read


     if File.readlines("public/twilio_error.txt").size > 0
       logger.info "this iserror"
    flash[:notice] = @read_file
     render "new"
    end



  end

  def create
    @phone_number = PhoneNumber.find_or_create_by(phone_number: params[:phone_number][:phone_number])
    @phone_number.generate_pin
    @phone_number.send_pin
    respond_to do |format|
      format.js # render app/views/phone_numbers/create.js.erb
    end
  end

  def verify
    @phone_number = PhoneNumber.find_by(phone_number: params[:hidden_phone_number])


    #write number to file bc i couldn't get it into the next controller with instance variable!!!
    cell = ''
    cell = params[:hidden_phone_number]
    File.open('public/cell.txt', 'w') {|file| file.write(cell)}


    if @phone_number.pin == (params[:pin2])
      @phone_number.verified = true

    respond_to do |format|
      format.js { render :js => "window.location = '/users/sign_up'"}
    end
      else
      @phone_number.verified  = false
      respond_to do |format|
        format.js

    end

    end

  end

end
