require 'formula'

class Wkhtmltopdf < Formula
  homepage 'http://wkhtmltopdf.org'
  url 'https://github.com/wkhtmltopdf/wkhtmltopdf/archive/0.12.1.tar.gz'
  sha1 'f8d1523d52891014b79f25e0d74d0f90e459b1d6'
  version '0.12.1'

  depends_on 'qt'

  option 'ignore-user-input', 'Ignores user input events'

  def install
    if build.include? 'ignore-user-input'
      inreplace 'src/lib/converter.cc' do |s|
        s.gsub! 'QEventLoop::WaitForMoreEvents | QEventLoop::AllEvents', 'QEventLoop::ExcludeUserInputEvents'
      end
    end

    if MacOS.version >= :mavericks && ENV.compiler == :clang
      spec = 'unsupported/macx-clang-libc++'
    else
      spec = 'macx-g++'
    end

    system 'qmake', '-spec', spec
    system 'make'
    ENV['DYLD_LIBRARY_PATH'] = './bin'
    `bin/wkhtmltopdf --manpage > wkhtmltopdf.1`
    `bin/wkhtmltoimage --manpage > wkhtmltoimage.1`

    # install binaries, libs, and man pages
    bin.install Dir[ "bin/wkh*" ]
    lib.install Dir[ "bin/lib*" ]
    man1.install Dir[ "wkht*.1" ]
  end
end
