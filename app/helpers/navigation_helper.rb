# frozen_string_literal: true

module NavigationHelper
  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page

    css_class = current_page == title ? '!text-gray-900' : 'text-gray-500'

    options[:class] = if options[:class]
                        "#{options[:class]} #{css_class}"
                      else
                        css_class
                      end

    link_to title, url, options
  end

  def currently_at(current_page = '')
    render partial: 'shared/navigations/header', locals: { current_page: }
    render partial: 'shared/navigations/footer', locals: { current_page: }
  end

  def full_title(page_title = '')
    base_title = 'Relomio'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  def current_locale_path(locale)
    url = request.original_url

    if url.include?('/sign_in')
      new_session_path(resource, locale:)
    elsif url.include?('/confirmation/new')
      new_confirmation_path(resource, locale:)
    elsif url.include?('/password/new')
      new_password_path(resource, locale:)
    else
      url_for(locale:)
    end
  end
end
