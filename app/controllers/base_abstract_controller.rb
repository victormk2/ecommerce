class BaseAbstractController < ApplicationController
  def index
    records = get_records

    if records.empty?
      return render json: {}, status: :ok
    end

    render json: records.map { |record| serializer_class.new(record).serializable_hash[:data][:attributes] }
  end

  def show
    record = model_class.find_by(get_params)

    if record
      render json: serializer_class.new(record).serializable_hash[:data][:attributes]
    else
      render json: { error: "Record not found" }, status: :not_found
    end
  end

  def create
    record = model_class.new(permitted_params)

    if record.save
      render json: serializer_class.new(record).serializable_hash[:data][:attributes], status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    record = model_class.find(params[:id])
    if record
      record.destroy
      render json: {}, status: :no_content
    else
      render json: { error: "Record not found" }, status: :not_found
    end
  end

  private

  def model_class
    raise NotImplementedError, "You must define the model_class method"
  end

  def serializer_class
    raise NotImplementedError, "You must define the serializer_class method"
  end

  def permitted_params
    raise NotImplementedError, "You must define the permitted_params method"
  end

  def search_params
    [ "id" ]
  end

  def get_records
    get_index_filter
  end

  def get_params
    permitted_params = search_params.map { |param| param.to_sym }
    params.permit(permitted_params)

    search_params.map do |param|
      { param => params[param] }
    end
  end

  def get_index_filter
    list_name = []
    values = []
    params_values = get_params
    params_values = params_values.map do |param|
      param.select do |key, value|
        if value
          values << value
          list_name << key
          param
        end
      end
    end

    scope_name = ""

    list_name.each do |name|
      add_string = scope_name.empty? ? "by_#{name}" : "_and_by_#{name}"
      scope_name << add_string
    end

    if model_class.respond_to?(scope_name.to_sym)
      model_class.send(scope_name.to_sym, *values)
    else
      model_class.index_filter
    end
  end
end
