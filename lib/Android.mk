LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/Makefile.sources

include $(CLEAR_VARS)

$(shell cp $(LOCAL_PATH)/version.h.in  $(LOCAL_PATH)/version.h)
$(shell cp $(LOCAL_PATH)/../config.h  $(LOCAL_PATH))

LOCAL_C_INCLUDES += $(LOCAL_PATH)/.. \
                    $(LOCAL_PATH)/stubs/drm/

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)

LOCAL_CFLAGS += -DHAVE_LIBDRM_ATOMIC_PRIMITIVES
LOCAL_CFLAGS += -DHAVE_STRUCT_SYSINFO_TOTALRAM
LOCAL_CFLAGS += -DANDROID -DHAVE_LINUX_KD_H
LOCAL_CFLAGS += -std=gnu99 -UNDEBUG
LOCAL_CFLAGS += -Wno-sometimes-uninitialized -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-sign-compare -Wno-missing-field-initializers
LOCAL_CFLAGS += -Wno-\#warnings
LOCAL_MODULE:= libintel_gpu_tools

LOCAL_SHARED_LIBRARIES := libpciaccess  \
			  libkmod       \
			  libdrm        \
			  libdrm_intel

ifeq ("${ANDROID_HAS_CAIRO}", "1")
    LOCAL_C_INCLUDES += external/cairo/src
    LOCAL_CFLAGS += -DANDROID_HAS_CAIRO=1 -DIGT_DATADIR=\".\" -DIGT_SRCDIR=\".\"
else
    skip_lib_list := \
    igt_kms.c \
    igt_kms.h \
    igt_fb.c
    -DANDROID_HAS_CAIRO=0
endif

LOCAL_SRC_FILES := $(filter-out %.h $(skip_lib_list),$(lib_source_list))

include $(BUILD_STATIC_LIBRARY)

include $(call first-makefiles-under, $(LOCAL_PATH))

