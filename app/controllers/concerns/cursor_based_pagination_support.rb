require 'base64'
require 'json'

module CursorBasedPaginationSupport
  extend ActiveSupport::Concern

  def generate_cursor(attr, value, direction)
    Base64.encode64({
      attr: attr,
      value: value.is_a?(String) ? "'#{value}'" : value,
      direction: direction
    }.to_json)
  end

  def cbp_scope(klass, encoded_cursor)
    results = if params[:cursor]
      cursor = decode_cursor(encoded_cursor)
      klass.where(where_conditions(cursor))
        .order("#{cursor['attr']} #{order(cursor)}")
    else
      klass.order("id asc")
    end.limit(20).to_a

    results.tap do |r|
      if params[:cursor] && order(cursor) == 'desc'
        results.reverse!
      end
    end
  end

  def decode_cursor(cursor)
    JSON.parse(Base64.decode64(cursor))
  end

  private

  def where_conditions(cursor)
    cursor.fetch_values('attr', 'direction', 'value').join(" ")
  end

  def order(cursor)
    cursor['direction'] == '<' ? 'desc' : 'asc'
  end
end
