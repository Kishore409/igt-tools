LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/Makefile.sources

LOCAL_TOOLS_DIR := intel/validation/core/igt/tools

#================#

define add_tool
    include $(CLEAR_VARS)

    ifeq ($($(1)_SOURCES),)
        LOCAL_SRC_FILES := $1.c
    else
        LOCAL_SRC_FILES := $(filter-out %.h,$($(1)_SOURCES))
    endif

    LOCAL_CFLAGS += -DHAVE_TERMIOS_H
    LOCAL_CFLAGS += -DHAVE_STRUCT_SYSINFO_TOTALRAM
    LOCAL_CFLAGS += -DANDROID -UNDEBUG
    LOCAL_CFLAGS += -std=gnu99
    # FIXME: drop once Bionic correctly annotates "noreturn" on pthread_exit
    LOCAL_CFLAGS += -Wno-error=return-type
    # Excessive complaining for established cases. Rely on the Linux version warnings.
    LOCAL_CFLAGS += -Wno-sign-compare
    LOCAL_LDFLAGS += -lkmod
    ifeq ($($(1)_LDFLAGS),)
    else
        LOCAL_LDFLAGS += $($(1)_LDFLAGS)
    endif

    LOCAL_C_INCLUDES = $(LOCAL_PATH)/../lib \
                       $(LOCAL_PATH)/../lib/stubs/drm/

    LOCAL_MODULE := $1_tool
    LOCAL_MODULE_TAGS := optional

    LOCAL_STATIC_LIBRARIES := libintel_gpu_tools

    LOCAL_SHARED_LIBRARIES := libpciaccess  \
                              libkmod       \
                              libdrm        \
                              libdrm_intel \
                              libz

    # Tools dir on host
    LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/$(LOCAL_TOOLS_DIR)
    # Tools dir on target.
    LOCAL_CFLAGS += -DPKGDATADIR=\"/system/vendor/$(LOCAL_TOOLS_DIR)\"

    include $(BUILD_EXECUTABLE)
endef

#================#

# Copy the register files
$(shell mkdir -p $(TARGET_OUT_VENDOR)/$(LOCAL_TOOLS_DIR)/registers)
$(shell cp $(LOCAL_PATH)/registers/* $(TARGET_OUT_VENDOR)/$(LOCAL_TOOLS_DIR)/registers)

bin_PROGRAMS := $(tools_prog_lists)

skip_tools_list := \
                   intel_guc_logger \
                   intel_reg \
                   intel_residency \
                   intel_framebuffer_dump \
                   intel_display_crc

ifeq ($(HAVE_LIBDRM_INTEL),true)
    bin_PROGRAMS += $(LIBDRM_INTEL_BIN)
    intel_error_decode_LDFLAGS = -lz
endif

tools_list := $(filter-out $(skip_tools_list),$(bin_PROGRAMS))

$(foreach item,$(tools_list),$(eval $(call add_tool,$(item))))
