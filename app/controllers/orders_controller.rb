class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :select_item, only: [:index, :create]
  before_action :set_public_key, only: [:index, :create]

  def index
    return redirect_to root_path if current_user.id == @item.user.id
    return redirect_to root_path if @item.order.present?

    @order_form = OrderForm.new
  end

  def create
    @order_form = OrderForm.new(order_params)
    if @order_form.valid?
      pay_item
      @order_form.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_form).permit(:postcode, :prefecture_id, :city, :block, :building, :phone_number).merge(
      user_id: current_user.id, item_id: params[:item_id], token: params[:token]
    )
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,  # 商品の値段
      card: order_params[:token],    # カードトークン
      currency: 'jpy'                 # 通貨の種類（日本円）
    )
  end

  def select_item
    @item = Item.find(params[:item_id])
  end

  def set_public_key
    gon.publick_key = ENV["PAYJP_PUBLIC_KEY"]
  end
end