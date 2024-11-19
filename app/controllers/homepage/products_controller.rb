class Homepage::ProductsController < Homepage::BaseController
  private

  def model_class
    Product
  end

  def serializer_class
    Homepage::ProductSerializer
  end

  def permitted_params
    params.require(:product).permit(:name, :description)
  end

  def search_params
    [ "name", "description" ]
  end
end
