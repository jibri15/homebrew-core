class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.10.0/libaacs-0.10.0.tar.bz2"
  sha256 "93f6b19ef71e6f73e77bd7535946c09c45330e9b42e832a63a1d6b042f6b12fe"

  bottle do
    cellar :any
    sha256 "9c3fbec79dd315fe3cdc3c4cb414e2ec925ee0afa3e8cbe1a134252e46f689a7" => :catalina
    sha256 "2071dce1ff86c499e3e97c90848e61041d98477c0e50faec10701acd0de7f8d8" => :mojave
    sha256 "b423d7825fa1695fb9099c0f6f00ea0b460c697878badc2a710900c8e3a55c39" => :high_sierra
    sha256 "07efaa70031e035a007873916e1e288c830b67095c140e358a71801b044c86a9" => :sierra
    sha256 "89afae75a0b0969298bb38cc14de93b2f8a713d4fa15ab62c7bc0f265003d1d4" => :el_capitan
    sha256 "0b3b29f19f636b25e95321aeffbd54303aec2cbca4641671d825284f6cd81fc7" => :yosemite
  end

  head do
    url "https://code.videolan.org/videolan/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libaacs/aacs.h"
      #include <stdio.h>

      int main() {
        int major_v = 0, minor_v = 0, micro_v = 0;

        aacs_get_version(&major_v, &minor_v, &micro_v);

        printf("%d.%d.%d", major_v, minor_v, micro_v);
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laacs",
                   "-o", "test"
    system "./test"
  end
end
