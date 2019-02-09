module Hubspot
  class PagedCollection
    delegate_missing_to :resources

    attr_accessor :offset, :limit

    def initialize(opts = {}, &block)
      @limit_param = opts.delete(:limit_param) || "limit"
      @limit = opts.delete(:limit) || 25
      @offset_param = opts.delete(:offset_param) || "offset"
      @offset = opts.delete(:offset)

      @options = opts

      @fetch_proc = block
      fetch
    end

    def refresh
      fetch
      self
    end

    def resources
      @resources
    end

    def more?
      @has_more
    end

    def next_offset
      @next_offset
    end

    def next_page?
      @has_more
    end

    def next_page
      @offset = next_offset
      fetch
      self
    end

  protected
    def fetch
      @resources, @next_offset, @has_more = @fetch_proc.call(@options, @offset, @limit)
    end
  end
end