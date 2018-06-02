module ApplicationHelper

  def amount(value)
    number_with_precision(value, :precision => 2, :separator => '.', :delimiter => '')
  end

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

  def form_number(f, name, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        mn = @model.human_attribute_name(name)
        haml_concat mn
      end
      haml_tag :td do
        haml_concat f.number_field name
      end
    end
  end

  # def form_amount(f, name, _class = nil)
  #   haml_tag :tr, :class => _class do
  #     haml_tag :th do
  #       mn = @model.human_attribute_name(name)
  #       haml_concat mn
  #     end
  #     haml_tag :td do
  #       haml_concat f.number_field name, value: number_to_currency(f.object.amount.to_f, delimiter: '.', unit: ''), step: :any
  #
  #     end
  #   end
  # end

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

  def form_select(f, name, collection=nil,_class = nil)
    collection = name.to_s.classify.constantize unless collection
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.collection_select "#{name}_id", collection.all, :id, :name, :include_blank => true
      end
    end
  end


  def form_date(f, name, year = nil, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.date_select name, include_blank: true, default: nil
      end
    end
  end

  def form_time(f, name, year = nil, _class = nil)
    haml_tag :tr, :class => _class do
      haml_tag :th do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :td do
        haml_concat f.time_select name, time_separator: '', include_blank: true, default: nil
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
        haml_concat image_submit_tag('square.round.fill.png', :title => t(:save))
      end
    end
  end


  def line(name, value = nil)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        value = @object.send(name) unless value
        if value.instance_of?(String) && value.start_with?('http://', 'https://')
          haml_concat link_to(value, value, target: "_blank")
        elsif value.instance_of?(ActiveRecord::Associations::CollectionProxy)
          haml_concat value.size
        else
          haml_concat value
        end
      end
    end
  end

  def line_text(name, value = nil)
    haml_tag :div, class: :line do
      haml_tag :div, class: :text, id: :name do
        haml_concat @object.send(name)
      end
    end
  end

  # first line with edit link
  def line_first(name = :name)
    haml_tag :div, class: :line do
      haml_tag :div, class: :label do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, class: :edit, id: name do
        haml_concat link_to(@object.send(name), {action: :edit, id: @object}, title: t(:edit, model: @object.name))
      end
    end
  end

  # object with name
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

  # link to object with name
  def line_link(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        relation = @object.send(name)
        haml_concat link_to(relation.name, relation) if relation
      end
    end
  end

  # list of objects with name
  def line_list(name)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        list(@object, name)
      end
    end
  end


  def line_date(name, format = :default)
    haml_tag :div, :class => 'line' do
      haml_tag :div, :class => 'label' do
        haml_concat @model.human_attribute_name(name)
      end
      haml_tag :div, :class => 'show', :id => name do
        if @object.send(name)
          date = @object.send(name)
          haml_concat l(date, format: format)
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
        if @model.method_defined? :currency
          currency = @object.send(:currency)
          haml_concat currency.sign if currency
        end
        value = @object.send(name)
        haml_concat number_with_precision(value, :precision => 2, :separator => '.', :delimiter => '') if value
      end
    end
  end

  def create
    haml_tag :div, class: :button do
      haml_concat link_to(image_tag('square.png'), {action: :new}, title: t(:add_new, model: @model.model_name.human))
    end
  end

  def edit
    haml_tag :div, class: :button do
      haml_concat link_to(image_tag('square.round.png'), {action: :edit, id: @object.id}, title: t(:edit, model: @model.model_name.human))
    end
  end

  def delete
    if @object && @object.persisted?
      haml_tag :div, class: :button do
        haml_concat link_to(image_tag('square.round.cross.png'),
                            {action: :destroy, id: @object},
                            method: :delete, title: t(:delete, model: @object.name), class: :delete,
                            data: {confirm: t(:delete_question, name: @object.name)})
      end
    end
  end


  def th(name)
    haml_tag :th do
      haml_concat link_to(@model.human_attribute_name(name), action: :sort, field: name)
    end
  end

  def list(object, name)
    object.send(name).each do |item|
      haml_concat link_to(item.name, {controller: name, action: :show, id: item.id})
    end
  end

  def list_name(object, name)
    object.send(name).each do |item|
      haml_concat link_to(item.name, {controller: name, action: :show, name: item.name})
    end
  end


end
