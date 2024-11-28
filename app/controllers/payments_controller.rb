# class PaymentsController < ApplicationController
#   require 'stripe'

#   Stripe.api_key = ENV['STRIPE_SECRET_KEY']

#   def create
#     begin
#       # Create a PaymentIntent with the specified amount and currency
#       payment_intent = Stripe::PaymentIntent.create(
#         amount: params[:amount],
#         currency: 'usd',
#         payment_method: params[:payment_method_id],
#         description: "Export transaction for product or service",
#         confirm: true,
#          return_url: "http://localhost:3000/payment/success",
#       )

#       render json: { success: true, payment_intent: payment_intent }
#     rescue Stripe::CardError => e
#       render json: { success: false, error: e.message }
#     end
#   end
# end

class PaymentsController < ApplicationController
  require 'stripe'

  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  def create
    begin
      # Ensure you have customer name and address from the frontend
      customer_name = params[:name]  # This should be passed from the frontend
      customer_address = {
        line1: params[:address_line1],  # Frontend should send this address
        city: params[:address_city],    # City
        state: params[:address_state],  # State
        postal_code: params[:address_postal_code],  # Postal code
        country: params[:address_country],  # Country code, e.g., "IN" for India
      }

      payment_intent = Stripe::PaymentIntent.create({
        amount: params[:amount], 
        currency: 'usd',  # Or INR if accepting payments in India
        payment_method: params[:payment_method_id],
        confirm: true,
        description: "Export transaction for product or service",  # Add a description
        return_url: "http://localhost:3000/payment/success",  # Optional return URL for redirects
        shipping: {
          name: customer_name,
          address: customer_address
        }
      })

      render json: { success: true, client_secret: payment_intent.client_secret }
    rescue Stripe::CardError => e
      render json: { success: false, error: e.message }
    end
  end
end
