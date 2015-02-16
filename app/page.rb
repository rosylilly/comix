class Page
  ALLOWED_EXTS = %w(
    jpg
    png
    bmp
    tif
    tiff
  )

  def initialize(entry)
    @entry = entry
  end

  def error
    errorPtr = Pointer.new(:object)
    @entry.check(errorPtr)
    errorPtr ? errorPtr[0] : nil
  end

  def fileName
    @entry.fileName || ''
  end

  def ext
    @ext ||= File.extname(fileName).sub(/^\./, '').downcase
  end

  def allowed?
    ALLOWED_EXTS.include?(ext)
  end

  def image
    NSImage.alloc.initWithData(@entry.newDataWithError(nil))
  end
end
