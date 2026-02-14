WickedPdf.config = {
  exe_path: File.exist?('/usr/bin/wkhtmltopdf') ? '/usr/bin/wkhtmltopdf' : '/usr/local/bin/wkhtmltopdf'
} if Rails.env.development? && RbConfig::CONFIG['host_os'] =~ /linux/
