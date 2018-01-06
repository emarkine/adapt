module ApplicationHelper


  def boolean_tag(value)
    value ? image_tag('true.gif') : image_tag('false.gif')
  end


  def form_error(o)
    if o.errors.any?
      haml_tag :div, :id => 'error_explanation' do
        haml_tag :h2 do
          haml_concat t(:error_save)
        end
        haml_tag :ul do
          o.errors.full_messages.each do |msg|
            haml_tag :li do
              haml_concat msg
            end
          end
        end
      end
    end
  end


  def line(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        value = @object.send(name)
        if value.instance_of?(String) && value.start_with?('http://', 'https://')
          haml_concat link_to(value, value, target: "_blank")
        else
          haml_concat value
        end
      end
    end
  end

  def line_name(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        haml_concat @object.send(name).name if @object.send(name)
      end
    end
  end

  def line_link(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        if @object.send(name)
          haml_concat link_to(@object.send(name).name, @object.send(name))
        end
      end
    end
  end

  def line_date(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        if @object.send(name)
          date = @object.send(name)
          haml_concat l(date, :format => :date)
        end
      end
    end
  end

  def line_time(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        if @object.send(name)
          time = @object.send(name)
          haml_concat l(time, :format => :h_m)
        end
      end
    end
  end

  def line_boolean(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        value = @object.send(name)
        if value
          haml_concat image_tag('true.gif')
        else
          haml_concat image_tag('false.gif')
        end
      end
    end
  end

  def line_amount(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        currency = @object.send(:currency)
        haml_concat currency.sign if currency
        value = @object.send(name)
        haml_concat number_with_precision(value, :precision => 2, :separator => '.', :delimiter => '') if value
      end
    end
  end


end
