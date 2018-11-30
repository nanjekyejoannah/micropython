# where py object files go (they have a name prefix to prevent filename clashes)
PY_BUILD = $(BUILD)/py

# where autogenerated header files go
HEADER_BUILD = $(BUILD)/genhdr

# file containing qstr defs for the core Python bit
PY_QSTR_DEFS = $(PY_SRC)/qstrdefs.h

# If qstr autogeneration is not disabled we specify the output header
# for all collected qstrings.
ifneq ($(QSTR_AUTOGEN_DISABLE),1)
QSTR_DEFS_COLLECTED = $(HEADER_BUILD)/qstrdefs.collected.h
endif

# Any files listed by this variable will cause a full regeneration of qstrs
QSTR_GLOBAL_DEPENDENCIES += $(PY_SRC)/mpconfig.h mpconfigport.h

# some code is performance bottleneck and compiled with other optimization options
CSUPEROPT = -O3

# this sets the config file for FatFs
CFLAGS_MOD += -DFFCONF_H=\"lib/oofatfs/ffconf.h\"

ifeq ($(MICROPY_PY_USSL),1)
CFLAGS_MOD += -DMICROPY_PY_USSL=1
ifeq ($(MICROPY_SSL_AXTLS),1)
CFLAGS_MOD += -DMICROPY_SSL_AXTLS=1 -I$(TOP)/lib/axtls/ssl -I$(TOP)/lib/axtls/crypto -I$(TOP)/extmod/axtls-include
AXTLS_DIR = lib/axtls
$(BUILD)/$(AXTLS_DIR)/%.o: CFLAGS += -Wno-all -Wno-unused-parameter -Wno-uninitialized -Wno-sign-compare -Wno-old-style-definition $(AXTLS_DEFS_EXTRA)
SRC_MOD += $(addprefix $(AXTLS_DIR)/,\
	ssl/asn1.c \
	ssl/loader.c \
	ssl/tls1.c \
	ssl/tls1_svr.c \
	ssl/tls1_clnt.c \
	ssl/x509.c \
	crypto/aes.c \
	crypto/bigint.c \
	crypto/crypto_misc.c \
	crypto/hmac.c \
	crypto/md5.c \
	crypto/rsa.c \
	crypto/sha1.c \
	)
else ifeq ($(MICROPY_SSL_MBEDTLS),1)
# Can be overridden by ports which have "builtin" mbedTLS
MICROPY_SSL_MBEDTLS_INCLUDE ?= $(TOP)/lib/mbedtls/include
CFLAGS_MOD += -DMICROPY_SSL_MBEDTLS=1 -I$(MICROPY_SSL_MBEDTLS_INCLUDE)
LDFLAGS_MOD += -L$(TOP)/lib/mbedtls/library -lmbedx509 -lmbedtls -lmbedcrypto
endif
endif

#ifeq ($(MICROPY_PY_LWIP),1)
#CFLAGS_MOD += -DMICROPY_PY_LWIP=1 -I../lib/lwip/src/include -I../lib/lwip/src/include/ipv4 -I../extmod/lwip-include
#endif

ifeq ($(MICROPY_PY_LWIP),1)
LWIP_DIR = lib/lwip/src
INC += -I$(TOP)/lib/lwip/src/include -I$(TOP)/lib/lwip/src/include/ipv4 -I$(TOP)/extmod/lwip-include
CFLAGS_MOD += -DMICROPY_PY_LWIP=1
SRC_MOD += extmod/modlwip.c lib/netutils/netutils.c
SRC_MOD += $(addprefix $(LWIP_DIR)/,\
	core/def.c \
	core/dns.c \
	core/init.c \
	core/mem.c \
	core/memp.c \
	core/netif.c \
	core/pbuf.c \
	core/raw.c \
	core/stats.c \
	core/sys.c \
	core/tcp.c \
	core/tcp_in.c \
	core/tcp_out.c \
	core/timers.c \
	core/udp.c \
	core/ipv4/autoip.c \
	core/ipv4/icmp.c \
	core/ipv4/igmp.c \
	core/ipv4/inet.c \
	core/ipv4/inet_chksum.c \
	core/ipv4/ip_addr.c \
	core/ipv4/ip.c \
	core/ipv4/ip_frag.c \
	)
ifeq ($(MICROPY_PY_LWIP_SLIP),1)
CFLAGS_MOD += -DMICROPY_PY_LWIP_SLIP=1
SRC_MOD += $(LWIP_DIR)/netif/slipif.c
endif
endif

ifeq ($(MICROPY_PY_BTREE),1)
BTREE_DIR = lib/berkeley-db-1.xx
BTREE_DEFS = -D__DBINTERFACE_PRIVATE=1 -Dmpool_error=printf -Dabort=abort_ "-Dvirt_fd_t=void*" $(BTREE_DEFS_EXTRA)
INC += -I$(TOP)/$(BTREE_DIR)/PORT/include
SRC_MOD += extmod/modbtree.c
SRC_MOD += $(addprefix $(BTREE_DIR)/,\
btree/bt_close.c \
btree/bt_conv.c \
btree/bt_debug.c \
btree/bt_delete.c \
btree/bt_get.c \
btree/bt_open.c \
btree/bt_overflow.c \
btree/bt_page.c \
btree/bt_put.c \
btree/bt_search.c \
btree/bt_seq.c \
btree/bt_split.c \
btree/bt_utils.c \
mpool/mpool.c \
	)
CFLAGS_MOD += -DMICROPY_PY_BTREE=1
# we need to suppress certain warnings to get berkeley-db to compile cleanly
# and we have separate BTREE_DEFS so the definitions don't interfere with other source code
$(BUILD)/$(BTREE_DIR)/%.o: CFLAGS += -Wno-old-style-definition -Wno-sign-compare -Wno-unused-parameter $(BTREE_DEFS)
$(BUILD)/extmod/modbtree.o: CFLAGS += $(BTREE_DEFS)
endif

# py object files
PY_CORE_O_BASENAME = $(addprefix py/,\
	mpstate.o \
	nlr.o \
	nlrx86.o \
	nlrx64.o \
	nlrthumb.o \
	nlrxtensa.o \
	nlrsetjmp.o \
	malloc.o \
	gc.o \
	pystack.o \
	qstr.o \
	vstr.o \
	mpprint.o \
	unicode.o \
	mpz.o \
	reader.o \
	lexer.o \
	parse.o \
	scope.o \
	compile.o \
	emitcommon.o \
	emitbc.o \
	asmbase.o \
	asmx64.o \
	emitnx64.o \
	asmx86.o \
	emitnx86.o \
	asmthumb.o \
	emitnthumb.o \
	emitinlinethumb.o \
	asmarm.o \
	emitnarm.o \
	asmxtensa.o \
	emitnxtensa.o \
	emitinlinextensa.o \
	formatfloat.o \
	parsenumbase.o \
	parsenum.o \
	emitglue.o \
	persistentcode.o \
	runtime.o \
	runtime_utils.o \
	scheduler.o \
	nativeglue.o \
	stackctrl.o \
	argcheck.o \
	warning.o \
	map.o \
	obj.o \
	objarray.o \
	objattrtuple.o \
	objbool.o \
	objboundmeth.o \
	objcell.o \
	objclosure.o \
	objcomplex.o \
	objdeque.o \
	objdict.o \
	objenumerate.o \
	objexcept.o \
	objfilter.o \
	objfloat.o \
	objfun.o \
	objgenerator.o \
	objgetitemiter.o \
	objint.o \
	objint_longlong.o \
	objint_mpz.o \
	objlist.o \
	objmap.o \
	objmodule.o \
	objobject.o \
	objpolyiter.o \
	objproperty.o \
	objnone.o \
	objnamedtuple.o \
	objrange.o \
	objreversed.o \
	objset.o \
	objsingleton.o \
	objslice.o \
	objstr.o \
	objstrunicode.o \
	objstringio.o \
	objtuple.o \
	objtype.o \
	objzip.o \
	opmethods.o \
	sequence.o \
	stream.o \
	binary.o \
	builtinimport.o \
	builtinevex.o \
	builtinhelp.o \
	modarray.o \
	modbuiltins.o \
	modcollections.o \
	modgc.o \
	modio.o \
	modmath.o \
	modcmath.o \
	modmicropython.o \
	modstruct.o \
	modsys.o \
	moduerrno.o \
	modthread.o \
	vm.o \
	bc.o \
	showbc.o \
	repl.o \
	smallint.o \
	frozenmod.o \
	)

PY_EXTMOD_O_BASENAME = \
	extmod/moductypes.o \
	extmod/modujson.o \
	extmod/modure.o \
	extmod/moduzlib.o \
	extmod/moduheapq.o \
	extmod/modutimeq.o \
	extmod/moduhashlib.o \
	extmod/moducryptolib.o \
	extmod/modubinascii.o \
	extmod/virtpin.o \
	extmod/machine_mem.o \
	extmod/machine_pinbase.o \
	extmod/machine_signal.o \
	extmod/machine_pulse.o \
	extmod/machine_i2c.o \
	extmod/machine_spi.o \
	extmod/modussl_axtls.o \
	extmod/modussl_mbedtls.o \
	extmod/modurandom.o \
	extmod/moduselect.o \
	extmod/modwebsocket.o \
	extmod/modwebrepl.o \
	extmod/modframebuf.o \
	extmod/vfs.o \
	extmod/vfs_reader.o \
	extmod/vfs_posix.o \
	extmod/vfs_posix_file.o \
	extmod/vfs_fat.o \
	extmod/vfs_fat_diskio.o \
	extmod/vfs_fat_file.o \
	extmod/utime_mphal.o \
	extmod/uos_dupterm.o \
	lib/embed/abort_.o \
	lib/utils/printf.o \

# prepend the build destination prefix to the py object files
PY_CORE_O = $(addprefix $(BUILD)/, $(PY_CORE_O_BASENAME))
PY_EXTMOD_O = $(addprefix $(BUILD)/, $(PY_EXTMOD_O_BASENAME))

# this is a convenience variable for ports that want core, extmod and frozen code
PY_O = $(PY_CORE_O) $(PY_EXTMOD_O)

# object file for frozen files
ifneq ($(FROZEN_DIR),)
PY_O += $(BUILD)/$(BUILD)/frozen.o
endif

# object file for frozen bytecode (frozen .mpy files)
ifneq ($(FROZEN_MPY_DIR),)
PY_O += $(BUILD)/$(BUILD)/frozen_mpy.o
endif

# Sources that may contain qstrings
SRC_QSTR_IGNORE = py/nlr%
SRC_QSTR = $(SRC_MOD) $(filter-out $(SRC_QSTR_IGNORE),$(PY_CORE_O_BASENAME:.o=.c)) $(PY_EXTMOD_O_BASENAME:.o=.c)

# Anything that depends on FORCE will be considered out-of-date
FORCE:
.PHONY: FORCE

$(HEADER_BUILD)/mpversion.h: FORCE | $(HEADER_BUILD)
	$(Q)$(PYTHON) $(PY_SRC)/makeversionhdr.py $@

# mpconfigport.mk is optional, but changes to it may drastically change
# overall config, so they need to be caught
MPCONFIGPORT_MK = $(wildcard mpconfigport.mk)

# qstr data
# Adding an order only dependency on $(HEADER_BUILD) causes $(HEADER_BUILD) to get
# created before we run the script to generate the .h
# Note: we need to protect the qstr names from the preprocessor, so we wrap
# the lines in "" and then unwrap after the preprocessor is finished.
$(HEADER_BUILD)/qstrdefs.generated.h: $(PY_QSTR_DEFS) $(QSTR_DEFS) $(QSTR_DEFS_COLLECTED) $(PY_SRC)/makeqstrdata.py mpconfigport.h $(MPCONFIGPORT_MK) $(PY_SRC)/mpconfig.h | $(HEADER_BUILD)
	$(ECHO) "GEN $@"
	$(Q)cat $(PY_QSTR_DEFS) $(QSTR_DEFS) $(QSTR_DEFS_COLLECTED) | $(SED) 's/^Q(.*)/"&"/' | $(CPP) $(CFLAGS) - | $(SED) 's/^"\(Q(.*)\)"/\1/' > $(HEADER_BUILD)/qstrdefs.preprocessed.h
	$(Q)$(PYTHON) $(PY_SRC)/makeqstrdata.py $(HEADER_BUILD)/qstrdefs.preprocessed.h > $@

# Force nlr code to always be compiled with space-saving optimisation so
# that the function preludes are of a minimal and predictable form.
$(PY_BUILD)/nlr%.o: CFLAGS += -Os

# optimising gc for speed; 5ms down to 4ms on pybv2
$(PY_BUILD)/gc.o: CFLAGS += $(CSUPEROPT)

# optimising vm for speed, adds only a small amount to code size but makes a huge difference to speed (20% faster)
$(PY_BUILD)/vm.o: CFLAGS += $(CSUPEROPT)
# Optimizing vm.o for modern deeply pipelined CPUs with branch predictors
# may require disabling tail jump optimization. This will make sure that
# each opcode has its own dispatching jump which will improve branch
# branch predictor efficiency.
# https://marc.info/?l=lua-l&m=129778596120851
# http://hg.python.org/cpython/file/b127046831e2/Python/ceval.c#l828
# http://www.emulators.com/docs/nx25_nostradamus.htm
#-fno-crossjumping
