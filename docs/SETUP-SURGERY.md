# V2.1 First-Setup Surgery

This revision prevents the live ISO from skipping setup or showing a name from an earlier test.

At every `boot=live` start, before LightDM:
- setup completion state is cleared
- user PIN files are cleared
- accidental regular test accounts are removed
- the temporary `zaone` live account is recreated/unlocked if required
- live autologin is restored
- stale AccountsService/LightDM user metadata is removed

The setup launcher then keeps reopening the setup window until account creation succeeds.
Installed systems are not reset because the surgery script exits unless the kernel command line contains `boot=live`.
