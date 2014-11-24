module ApplicationHelper
  def icon_tag(icon_sym, options = {})
    klass = "glyphicon glyphicon-#{icon_sym.to_s.gsub(?_, ?-)}"
    content_tag(:i, '', options.merge(class: klass))
  end

  def delete_action(resource, allowed = true, options = {})
    if allowed
      confirm = 'Tem certeza que deseja excluir este item?'
      link_to(icon_tag(:remove), resource, method: :delete, data: { confirm: confirm })
    else
      options[:tooltip] ||= 'Este item não pode ser excluído pois possui outros itens relacionados'
      icon_tag(:remove, style: 'opacity: 0.3', title: options[:tooltip], data: { toggle: 'tooltip' })
    end
  end
end
