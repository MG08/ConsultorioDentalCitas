class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @appointment = Appointment.find(params[:appointment_id])
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
     @appointment = Appointment.find(params[:appointment_id])
     respond_to do |format|
      format.html
      format.pdf do
      render  pdf: "Recibo",  
      title:                          'Recibo',            # otherwise first page title is used
               margin:  {   top:               50,                     # default 10 (mm)
                            bottom:            50,
                            left:              70,
                            right:             40 },
      template: "payments/show.html.erb"
    end
    end
  end

  # GET /payments/new
  def new
    @appointment = Appointment.find(params[:appointment_id])
    @appointment_procedures=AppointmentsProcedure.where(appointment_id: @appointment.id)
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
    @appointment = Appointment.find(params[:appointment_id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @appointment = Appointment.find(params[:appointment_id])
    @payment = Payment.new(payment_params)
    @payment.appointment_id=@appointment.id
    respond_to do |format|
      if @payment.save
        format.html { redirect_to appointment_payment_path(@payment.appointment,@payment), notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to appointment_payment_path(@payment.appointment,@payment), notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:tipo_pago,:costo_total)
    end
end
