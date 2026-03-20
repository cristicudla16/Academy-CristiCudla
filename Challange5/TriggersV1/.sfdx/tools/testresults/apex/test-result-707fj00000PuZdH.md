# Apex Test Results
**Run completed:** 03/19/2026, 16:44:49

## Summary

- **Total Tests:** 5
- ✅ **Passed:** 3
- ❌ **Failed:** 2
- ⏱️ **Duration:** 810ms

## ❌ Failures (2)

### AccountAddressVerificationTest.testNullPostalCode

*Duration: 65ms*

**Error Message**

```
System.AssertException: Assertion Failed: Expected an exception due to null postal code.
```

**Stack Trace**

```
Class.AccountAddressVerificationTest.testNullPostalCode: line 62, column 1
```

---

### AccountAddressVerificationTest.testInvalidPostalCode

*Duration: 71ms*

**Error Message**

```
System.AssertException: Assertion Failed: Expected an exception due to invalid postal code.
```

**Stack Trace**

```
Class.AccountAddressVerificationTest.testInvalidPostalCode: line 48, column 1
```

---

## ✅ Passed Tests (3)

- AccountAddressVerificationTest.testValidBrazilianPostalCodeWithoutHyphen (533ms)
- AccountAddressVerificationTest.testValidBrazilianPostalCodeWithHyphen (74ms)
- AccountAddressVerificationTest.testValidRomanianPostalCode (67ms)

