# inclass07

Digital Pet Simulator
Contributors: Clarence Li, Seul An Kim

<Pathway>
Clarence Li : Care Systems
- Own feed/play/reset behavior, bounded meters, the hunger and win timers, game outcomes, and state-boundary tests.

Seul An Kim: Pet Personality
- Own derived pet messages, mood feedback, licensed pet assets, motion/accessibility polish, and interaction tests.

Pet status: shows happiness and hunger on a 0–100 scale and provides a readable mood label.
Mood tint: tints one transparent or grayscale pet asset with ColorFiltered: happiness above 70 is green, 30–70 is yellow, and below 30 is red. Also show text or an icon so color is not the only signal.
Name: allows the user to enter and confirm a pet name. Dispose of any TextEditingController your state object owns.
Actions: feed and play buttons update the related meters and show the result immediately.
Time: increases hunger by 5 every 30 seconds. During development, shorten the interval temporarily and restore 30 seconds before submission.
Win: happiness must remain above 80 continuously for 3 minutes.
Loss: game over when hunger is 100 and happiness is 10 or lower. Disable care actions after either outcome until restart.
Reset: restore the initial meters and outcome flags, cancel any running win timer, and ensure exactly one hunger timer is active.