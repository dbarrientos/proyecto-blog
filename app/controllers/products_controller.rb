class ProductsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:confirmation]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def pay
    @product = Product.find(params[:id])
    @payment = Payment.create

    @payment.order_id = @payment.id.to_s + SecureRandom.random_number(10).to_s
    @payment.session_id = SecureRandom.random_number(10).to_s
    @payment.amount = @product.price
    @payment.status = false
    @payment.save

    

    @tbk_tipo_transaccion = "TR_NORMAL"
    @tbk_url_cgi = "http://186.64.122.15/cgi-bin/cgidavid/tbk_bp_pago.cgi"
    @tbk_url_exito = "http://david.beerly.cl/products/success"
    @tbk_url_fracaso = "http://david.beerly.cl/products/failure"

  end

  def confirmation
    payment = Payment.where(order_id: params["TBK_ORDEN_COMPRA"]).where(session_id: params["TBK_ID_SESION"]).first
    render text: "RECHAZADO" if payment.nil?
    render text: "RECHAZADO" if payment.amount.to_s + "00" != params[:TBK_MONTO] 
    render text: "RECHAZADO" if !params.has_key?(:TBK_RESPUESTA) || !params.has_key?(:TBK_ORDEN_COMPRA) || !params.has_key?(:TBK_TIPO_TRANSACCION) || !params.has_key?(:TBK_MONTO) || !params.has_key?(:TBK_CODIGO_AUTORIZACION) || !params.has_key?(:TBK_FECHA_CONTABLE) || !params.has_key?(:TBK_HORA_TRANSACCION) || !params.has_key?(:TBK_ID_SESION) || !params.has_key?(:TBK_ID_TRANSACCION) || !params.has_key?(:TBK_TIPO_PAGO) || !params.has_key?(:TBK_NUMERO_CUOTAS) || !params.has_key?(:TBK_VCI) || !params.has_key?(:TBK_MAC)
    render text: "RECHAZADO" if payment.status

    payment.status = true
    logger.info "Hola me estoy llamando"
    render text: "ACEPTADO"
  end 

  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :price)
    end
end
