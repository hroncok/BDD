Feature: System Python
  https://fedoraproject.org/wiki/Changes/System_Python

  Separate several subpackages from the python3 packages -
  a system-python(-libs) that can be required by various tools
  that consider themselves "system tools".

  Background: Fedora 24
    Given system of interest is Fedora 24

  Scenario: system-python-libs
      Given system-python-libs package
       When its contents is examined
       Then it contains an undefined subset of standard Python 3 library
        And it does not contain asyncio

  Scenario: system-python
      Given system-python package
       When its contents and metadata are examined
       Then it contains a Python 3 interpreter in /usr/libexec/system-python
        And it can interpret Python 3 code
        And it provides system-python(abi)

  Scenario: python3-libs
      Given python3-libs package
       When its contents and metadata are examined
       Then it contains a remaining set of standard Python 3 library
        And it contains asyncio
        And it requires system-python-libs

  Scenario: python3
      Given python3 package
       When its metadata are examined
       Then it requires python3-libs
        And it provides python(abi)

  Scenario: Dependency chain
      Given a package that requires python(abi) = 3.x
       When it is installed
       Then both python3-libs and system-python-libs are installed as dependency

  Scenario: Macros
      Given a python package SRPM
       When we use a special provided macro
       Then the resulting binary RPM does not require python(abi) = 3.x
        But it requires system-python(abi) = 3.x instead

  @feature
  Scenario: dnf depends on system python
      Given dnf, python3 and python3-libs are installed
       When python3 and python3-libs are removed
       Then dnf is not removed
        And dnf still works
