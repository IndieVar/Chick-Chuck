# frozen_string_literal: true

# Formats comment and review counts using the current locale.
module LocalizedCount
  extend ActiveSupport::Concern

  COUNT_LABELS = {
    en: { comments: 'Comments', reviews: 'Reviews' }.freeze,
    ru: {
      comments: %w[Комментарий Комментария Комментариев].freeze,
      reviews: %w[Отзыв Отзыва Отзывов].freeze
    }.freeze,
    uk: {
      comments: %w[Коментар Коментара Коментарів].freeze,
      reviews: %w[Відгук Відгука Відгуків].freeze
    }.freeze,
    he: {
      comments: %w[הערה הערות].freeze,
      reviews: %w[תגובה תגובות].freeze
    }.freeze
  }.freeze

  private

  def localized_count(count, type)
    labels = COUNT_LABELS.dig(I18n.locale, type)
    return unless labels

    "#{count} #{localized_word(count, labels)}"
  end

  def localized_word(count, labels)
    return labels unless labels.is_a?(Array)
    return count == 1 ? labels.first : labels.last if labels.size == 2

    slavic_count_word(count, labels)
  end

  def slavic_count_word(count, forms)
    return forms.first if count == 1
    return forms.second if [2, 3, 4].include?(count)

    forms.last
  end
end
