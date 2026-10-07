# Urgent-help screen

Opened by the urgent button (on every screen) **or** automatically when `/v1/analyze` returns `urgent: true`. No AI text is ever shown on this screen.

The screen must still be complete and useful when `verified-contacts.md` has no entries (proposal §10: never show an urgent screen with nothing concrete on it).

### urgent_button
نحتاج مساعدة توا
> I need help now

The label of the button shown on every screen.

### urgent_title
سلامتك أهم حاجة توا
> Your safety matters most right now

### urgent_intro_auto
شكراً إنك كتبت اللي في قلبك. اللي كتبته يخلينا نبو نتأكد إنك بخير، وهذي خطوات تقدر تديرها توا.
> Thank you for writing what's on your mind. What you wrote makes us want to be sure you're OK, and here are steps you can take right now.

Shown only when the screen opened automatically after a message. Not shown when the user pressed the button.

### urgent_step_person
قول لحد قريب منك توا: صاحبك، حد من العيلة تثق فيه، جارك، أي حد تحس روحك معاه في أمان. ما تقعدش وحدك.
> Tell someone near you now: a friend, a family member you trust, a neighbour, anyone you feel safe with. Don't stay alone.

### urgent_step_hospital
لو حاسس إنك ممكن تأذي روحك، امشي لأقرب مستشفى، قسم الطوارئ، أو خلي حد يوصلك.
> If you feel you might hurt yourself, go to the nearest hospital emergency department, or have someone take you.

### urgent_step_safe_space
بعّد على روحك أي حاجة ممكن تأذيك، وخليك في مكان فيه ناس.
> Move away from anything that could hurt you, and stay somewhere with other people.

### urgent_contacts_title
أرقام تأكدنا منها
> Numbers we have checked

Show this section **only** if `verified-contacts.md` has at least one entry. Each entry is shown with `urgent_contact_verified`.

### urgent_contact_verified
تأكدنا إن الرقم هذا يرد يوم {date}
> We checked that this number answers on {date}

### urgent_no_contacts
لين توا ما قدرناش نتأكد من أي رقم يرد، عشان هكي ما حطيناش أرقام. الخطوات اللي فوق تقدر تديرها توا.
> So far we couldn't confirm that any number answers, so we haven't listed any. You can take the steps above right now.

Show this **instead of** the contacts section when there are no verified entries.

### urgent_message_button
اكتب رسالة لحد تثق فيه
> Write a message to someone you trust

Opens the message below, ready to copy or share. Nothing is sent automatically.

### urgent_message_text
أنا مش كويس توا ومحتاجك. تقدر تجيني أو تكلمني؟
> I'm not OK right now and I need you. Can you come or call me?

Fixed text. The user can edit it before sending it themselves.

### urgent_copy
انسخ الرسالة
> Copy the message

### urgent_share
ابعثها بنفسك
> Send it yourself

### urgent_back
رجوع
> Back

### urgent_footer
خطوة مش خدمة طوارئ، وما فيش حد يقرا كلامك. الخطوات هذي مكتوبة ومراجعة من الفريق، مش من الذكاء الاصطناعي.
> Khutwa is not an emergency service, and nobody reads your messages. These steps were written and reviewed by the team, not by the AI.
