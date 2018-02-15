module SnipSnapZap
  module SnipSnapHelper
    def button_class(type, params)
      classes = ["btn"]
      if params[:filter] && params[:filter][:snapable_type]
        classes << "btn-primary"
      else
        classes << "btn-default"
      end
      return classes
    end
  end
end