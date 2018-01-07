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

  def table_form_error(o)
    if o.errors.any?
      haml_tag :tr do
        haml_tag :td, class: :error, colspan: 2 do
          haml_concat t(:error_save)
        end
      end
      o.errors.full_messages.each do |msg|
        haml_tag :tr do
          haml_tag :td, class: :message, colspan: 2 do
            haml_concat msg
          end
        end
      end
    end
  end

  def form_field(f, name, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        mn = @model.human_attribute_name(name)
        haml_concat mn
      end
      haml_tag :td do
        haml_concat f.text_field name
      end
    end
  end

  def form_password(f, name, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        mn = @model.human_attribute_name(name)
        haml_concat mn
      end
      haml_tag :td do
        haml_concat f.password_field name
      end
    end
  end

  def form_area(f, name, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.text_area name
      end
    end
  end

  def form_select(f, name, collection_class, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.collection_select "#{name}_id", collection_class.all, :id, :name, :include_blank => true
      end
    end
  end

  def form_date(f, name, year = nil, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.date_select name, :start_year => year, :end_year => Time.now.year
      end
    end
  end

  def form_time(f, name, year = nil, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.time_select name, :time_separator => '', :include_blank => true
      end
    end
  end

  def form_boolean(f, name, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.check_box name
      end
    end
  end

  def form_submit(f)
    haml_tag :tr do
      haml_tag :td, colspan: 2 do
        # <input alt="Store" type="image" src="/assets/store-a68bb7d12213e09ab8afd1471e3cbb91.png" title="store">
        haml_concat image_submit_tag('store.png', :title => t(:save))
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
