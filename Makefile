# ==========================================
# General
# ==========================================
init: init-basics

tests: test-basics test-advanced test-specifics test-libraries

# ==========================================
# Basics
# ==========================================
init-basics:
	mix new basics

test-basics:
	cd basics && make tests && cd ..

# ==========================================
# Advanced
# ==========================================
init-advanced:
	mix new advanced

test-advanced:
	cd advanced && make tests && cd ..

# ==========================================
# Specifics
# ==========================================
init-specifics:
	mix new specifics

test-specifics:
	cd specifics && make tests && cd ..

# ==========================================
# Libraries
# ==========================================
init-libraries:
	mix new libraries

test-libraries:
	cd libraries && make tests && cd ..
