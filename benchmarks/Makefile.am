include Makefile.sources

SUBDIRS = wsim ezbench.d

benchmarks_PROGRAMS = $(benchmarks_prog_list)

if HAVE_LIBDRM_INTEL
benchmarks_PROGRAMS += $(LIBDRM_INTEL_BENCHMARKS)
endif

AM_CPPFLAGS = -I$(top_srcdir) -I$(top_srcdir)/lib
AM_CFLAGS = $(DRM_CFLAGS) $(CWARNFLAGS) $(CAIRO_CFLAGS) $(LIBUNWIND_CFLAGS) \
	    $(WERROR_CFLAGS) -D_GNU_SOURCE
LDADD = $(top_builddir)/lib/libintel_tools.la

benchmarks_LTLIBRARIES = gem_exec_tracer.la
gem_exec_tracer_la_LDFLAGS = -module -avoid-version -no-undefined
gem_exec_tracer_la_LIBADD = -ldl

gem_latency_CFLAGS = $(AM_CFLAGS) $(THREAD_CFLAGS)
gem_latency_LDADD = $(LDADD) -lpthread
gem_syslatency_CFLAGS = $(AM_CFLAGS) $(THREAD_CFLAGS)
gem_syslatency_LDADD = $(LDADD) -lpthread -lrt
gem_wsim_LDADD = $(LDADD) -lpthread

EXTRA_DIST= \
	README \
	meson.build \
	$(NULL)
