# You'd normally call this a set, but Redis already has another data type for that
class Kredis::Types::UniqueList < Kredis::Types::Proxying
  proxying :multi, :zrange, :zrem, :zadd, :zremrangebyrank, :exists?, :del

  attr_accessor :typed, :limit

  def elements
    strings_to_types(zrange(0, -1) || [], typed)
  rescue Redis::CommandError
    fallback_to_legacy(:elements)
  end
  alias to_a elements

  def remove(*elements)
    zrem(types_to_strings(elements, typed))
  rescue Redis::CommandError
    migrate_list_to_sorted_set
    retry
  end

  def prepend(elements)
    insert(elements, prepend: true)
  rescue Redis::CommandError
    migrate_list_to_sorted_set
    retry
  end

  def append(elements)
    insert(elements)
  rescue Redis::CommandError
    migrate_list_to_sorted_set
    retry
  end
  alias << append

  private
    def insert(elements, prepend: false)
      elements = Array(elements)
      return if elements.empty?

      elements_with_scores = types_to_strings(elements, typed).map do |element|
        [ current_nanoseconds(negative: prepend), element ]
      end

      multi do
        zadd(elements_with_scores)
        trim(from_beginning: prepend)
      end
    end

    def current_nanoseconds(negative:)
      "%10.9f" % (negative ? -Time.now.to_f : Time.now.to_f)
    end

    def trim(from_beginning:)
      return unless limit&.positive?

      if from_beginning
        zremrangebyrank(limit, -1)
      else
        zremrangebyrank(0, -(limit + 1))
      end
    end

    def fallback_to_legacy(method)
      legacy_list.send(method)
    end

    def migrate_list_to_sorted_set
      legacy_elements = legacy_list.elements
      legacy_list.del
      append(legacy_elements)
    end

    def legacy_list
      Kredis.unique_list_legacy(key, typed: typed, limit: limit, config: config, after_change: after_change)
    end
end
