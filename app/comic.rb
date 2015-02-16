class Comic
  ALLOWED_EXTS = %w(
    zip
    cbz
    epub
  )

  EXPECTED_ENCODINGS = [
    NSUTF8StringEncoding,
    NSShiftJISStringEncoding,
    NSJapaneseEUCStringEncoding,
    NSASCIIStringEncoding
  ]

  def initialize(path)
    @path = path
    @error = nil
    @cursor = 0
  end
  attr_reader :path, :error
  attr_accessor :cursor

  def archive
    @archive ||= begin
      encodings = EXPECTED_ENCODINGS.clone
      archive = nil

      while !archive && !encodings.empty?
        encoding = encodings.shift

        error_ptr = Pointer.new(:object)
        archive = ZZArchive.alloc.initWithURL(
          NSURL.fileURLWithPath(@path),
          options: {
            ZZOpenOptionsEncodingKey => encoding
          },
          error: error_ptr
        )
        @error = error_ptr[0] if error_ptr

        archive = nil if !archive.entries.empty? && archive.entries[0].fileName.nil?
      end

      archive
    end
  end

  def pages
    @pages ||= archive.entries.map { |entry|
      Page.new(entry)
    }.
    select(&:allowed?).
    sort_by(&:fileName)
  end

  def currentPages
    [
      getPage((@cursor*2) - 1),
      getPage(@cursor*2),
    ]
  end

  def maxCursor
    (pages.size / 2).floor
  end

  private

  def getPage(index)
    return nil if index < 0 || index >= pages.length

    pages[index]
  end
end
