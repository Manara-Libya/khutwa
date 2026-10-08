# Khutwa: evidence for the pitch

Every claim we make on stage and in Q&A, with its source and how strong it is. Use the wording in the "Say" lines; the full safe and unsafe claims table is in `docs/challenge-brief.md` Appendix C and proposal §11.

**Strength labels**

| Label | Meaning |
|---|---|
| **Strong** | Systematic review or meta-analysis, consistent findings. |
| **Moderate** | Good studies, but fewer, or not in our exact setting. |
| **Early** | One study, no control group, or a different population. |
| **Libya** | A study or report about Libya, with the stated sample and limits; never a national figure. |

Numbers in brackets such as [6] point to the source list at the end.

---

## 1. The problem in Libya

| Claim | Evidence | Strength |
|---|---|---|
| Distress among young people is documented. | 427 secondary students aged 15–19 in Souq Al-Jumaa, Tripoli: 47 reported a suicide attempt in the past year [6]. | Libya (self-report, minors, one area) |
| Very few get professional help. | Of those 427 students, 13 reported getting help afterwards from a doctor, counsellor, therapist or hotline [6]. | Libya |
| Specialists are scarce, and referral routes are informal. | WHO 2025 situation analysis: scarce mental-health data, lack of facilities, shortage of professionals, stigma, southern shortages [3]. UNICEF 2023: informal referral routes [2]. | Libya |
| Stigma and confidentiality fears keep students away; they rely on trusted family and friends. | 21 interviews at one Benghazi university [5]. | Libya (thesis, one campus) |
| The assistant must understand Libyan dialect. | Libyan dialect differs enough to need its own handling [14]. | Moderate |

**Say:** "In one Tripoli school survey, 47 of 427 students reported a suicide attempt in the past year, and 13 reported getting professional help afterwards. Studies in Libya document stigma, confidentiality fears and scarce, informal referral routes."
**Don't say:** any national percentage, "97% get no help" or "only 3% got help" (see Appendix C for why).

---

## 2. Why this approach works

### 2.1 The goal: getting young people to a real person

| Claim | Evidence | Strength |
|---|---|---|
| People in our lives protect us. | Meta-analysis of 148 studies (308,849 people): stronger social relationships went with about 50% higher odds of survival (OR 1.50), comparable to well-known health risk factors [21]. | Strong |
| Feeling that someone is there for you buffers stress. | The *perceived availability* of someone responsive to your needs protects against the effects of stressful events [22]. | Strong (classic review) |
| Young people go to friends and family first. | Young people prefer informal help, especially friends, before professionals [23]. Benghazi students rely on trusted family and friends [5]. | Strong, plus Libya |

### 2.2 The barriers Khutwa removes

| Barrier (from the research) | What Khutwa does | Evidence | Strength |
|---|---|---|---|
| Stigma and embarrassment | A private start, no account; a non-judging listener before any person | Top barrier in a systematic review of 22 studies of young people [24]; also in Arab populations [15, 16] | Strong |
| Fear that others will find out | Names, places and numbers removed on the phone before anything is sent | Confidentiality is a recurring barrier in Arab populations [15] and in Libya [5] | Strong, plus Libya |
| Wanting to handle it alone | No diagnosis, no lecture; the user chooses who and what to send | Preference for self-reliance is a top barrier [24] | Strong |
| Not knowing who to go to or what to say | 2–3 suggested people with a reason each, and a drafted first message | Social support and encouragement from others are the main facilitators [24] | Strong |

### 2.3 Listening first

| Claim | Evidence | Strength |
|---|---|---|
| People open up more when they believe they are talking to a computer. | Participants who thought a virtual interviewer was automated feared disclosure less, managed impressions less and shared more, including sadness [25]. | Moderate |
| Khutwa's listening style comes from a tested method. | It uses motivational-interviewing listening skills (open questions, affirmations). Across 119 studies, motivational interviewing had small, lasting effects against weak comparisons (g = 0.28), and was about equal to other active treatments [26]. | Strong (for the method, not for Khutwa) |
| The arc of the conversation follows WHO Psychological First Aid: look, listen, link. | WHO's standard for supporting people in distress. Training improves helpers' skills, but outcome evidence is thin and at high risk of bias [27, 28]. | Evidence-informed, **not proven** |

### 2.4 The first step: a message ready to send

| Claim | Evidence | Strength |
|---|---|---|
| A concrete plan (when, what, to whom) makes people far more likely to act. | Implementation intentions: d = 0.65 on goal attainment across 94 tests [29]. Khutwa's drafted message is that kind of plan. | Strong for the mechanism, untested for help-seeking |
| Information alone rarely changes behaviour; that is why Khutwa ends in an action. | Anti-stigma interventions (97 trials, 43,852 young people): short-term gains in help-seeking attitudes (SMD 0.18) and intentions (0.14) only [30]. Web-based education raised knowledge, but had no significant effect on help-seeking intentions or attitudes [31]. | Strong |
| A chat can lead young people to real help. | krisenchat (German messenger counselling for young people): of 247 users referred to a service or a trusted adult, 48.6% made contact, and most of those had a talk or an appointment set up [32]. | Early (human counsellors, no control group) |

### 2.5 AI in mental health

| Claim | Evidence | Strength |
|---|---|---|
| AI conversational agents can reduce distress. | Meta-analysis of 15 randomised trials: reduced depression and distress symptoms, but not overall well-being [33]. | Moderate (mixed) |
| Youth chatbots often lack safety features. | 2025 scoping review: limited safety features; calls for stronger privacy and evaluation [19]. Khutwa's answer: fixed urgent screen, risk check that fails safe, no diagnosis. | Moderate |
| Responsible AI for mental health needs co-design, cultural and language adaptation, and accountable crisis referral. | WHO 2026 [17]; UNICEF guidance on AI and children: safety, privacy, transparency [18]. | Guidance |
| Mental-health apps often leak data. | Empirical study of mental-health app privacy [20]. Khutwa redacts on the phone and keeps no server logs. | Moderate |

**Say:** "Each step is built on published research: young people turn to friends first, stigma and fear of exposure hold them back, and a concrete plan makes action far more likely. We have not yet measured whether Khutwa increases help-seeking in Libya; that is our next step."
**Don't say:** "scientifically proven", "clinically validated", "evidence-based therapy".

---

## 3. What we measured ourselves

From `evals/results.md`, run on 7 October 2026 against the live API and the on-device redactor. All test messages are fictional. These are small sets: report counts and misses, never clinical claims.

| Test | Result |
|---|---|
| Risk detection | 19 of 20 risk phrasings caught (direct, indirect, Arabizi, misspelled); 0 of 10 harmless idioms raised a false alarm |
| Diagnosis refusal | 10 of 10 requests for a diagnosis or medicine handled safely |
| Dialect replies | 19 of 20 answered (median 13.3 s); naturalness rating pending |
| Redaction recall | 49 of 52 planted identifiers removed (94%), on the phone, offline |

**Re-run before the pitch.** The reflection prompt changed after this run (#88 no parroting, #90 look-listen-link), so the dialect and diagnosis rows need fresh numbers.

**Say:** "In our fictional test set, the phone removed 49 of 52 planted names and numbers, and the risk check caught 19 of 20 risk phrasings with no false alarms."

---

## 4. What the evidence does not show (say it before a judge does)

- No study shows that any digital tool increases help-seeking in Libya [brief §5.3].
- There is no national youth prevalence figure for Libya.
- Psychological First Aid is evidence-informed, not proven effective [27, 28].
- Evidence for chatbots is mixed: they reduce symptoms in trials, but not overall well-being [33].
- Our own tests are small, fictional sets, not a user study.

---

## 5. Judge questions, with the evidence

**"Why not just give information about mental health?"**
Information raises knowledge but barely moves help-seeking [30, 31]. Young people already turn to friends first [23]; what stops them is stigma, fear of exposure and not knowing what to say [24]. Khutwa removes those and ends with a message ready to send, a concrete plan, which is what moves people to act [29].

**"Isn't an AI the wrong listener for someone in distress?"**
People disclose more to a computer, because they fear judgement less [25]. Khutwa is not the support: it listens, then helps them reach a person. It never diagnoses, and the urgent-help screen is fixed text that does not depend on the AI.

**"Is this evidence-based?"**
Each design choice is grounded in published research (sections 2.1–2.5). Khutwa itself has not been tested for its effect on help-seeking yet; the validation plan is in the challenge brief §8.14.

**"Why trust family suggestions in Libya?"**
We don't assume family is safe. Suggestions come from a fixed list, each with a reason, and the user chooses. That follows the evidence that young people rely on trusted informal help [5, 23], while respecting that home is not always safe.

**"What about privacy?"**
Confidentiality is a reported barrier in Libya and the Arab region [5, 15]. Names, places and numbers are removed on the phone before anything is sent (49 of 52 in our tests). Nothing is stored on our server. Saved chats are off by default, and when turned on they stay encrypted on the phone.

---

## Sources

[2]–[20] are the numbered sources in `docs/challenge-brief.md` §12; the ones used here:

- [2] UNICEF MENA & UNICEF Libya. Integration of MHPSS in Primary Health Care — Libya. 2023.
- [3] WHO. Libya Public Health Situation Analysis. 2025. https://cdn.who.int/media/docs/default-source/2021-dha-docs/who-libya-phsa-2025.pdf
- [5] El-abbar, A. The perception of mental health amongst medical students and instructors in Libya. MSc thesis, University of Waterloo, 2023. https://uwspace.uwaterloo.ca/items/2343a1c0-7d48-48fd-bc10-b721e6652d8c
- [6] Ganbur, H. & Elhamadi, M. Mental health burden and sex disparities in Libyan secondary school students. AlQalam J Med Appl Sci, 2026. https://journal.utripoli.edu.ly/index.php/Alqalam/article/view/1877
- [14] Essgaer, M. et al. Computational Linguistics Meets Libyan Dialect. arXiv:2512.04257, 2025. https://arxiv.org/abs/2512.04257
- [15] Understanding experiences of mental health help-seeking in Arab populations around the world: a systematic review. BMC Psychiatry, 2023. https://bmcpsychiatry.biomedcentral.com/articles/10.1186/s12888-023-04827-4
- [16] Mental illness stigma and help-seeking attitudes in 16 Arab countries (10,036 people). Soc Psychiatry Psychiatr Epidemiol, 2023. https://link.springer.com/article/10.1007/s00127-022-02403-x
- [17] WHO. Towards responsible AI for mental health and well-being. 2026. https://www.who.int/news/item/20-03-2026-towards-responsible-ai-for-mental-health-and-well-being--experts-chart-a-way-forward
- [18] UNICEF Innocenti. Guidance on AI and Children, v3.0. 2025. https://www.unicef.org/innocenti/reports/policy-guidance-ai-children
- [19] Current landscape and future directions for mental health conversational agents for youth: scoping review. 2025. https://pmc.ncbi.nlm.nih.gov/articles/PMC11909484
- [20] On the privacy of mental health apps: an empirical investigation. 2022. https://pmc.ncbi.nlm.nih.gov/articles/PMC9643945/

New in this document:

- [21] Holt-Lunstad, J., Smith, T. B. & Layton, J. B. Social relationships and mortality risk: a meta-analytic review. PLoS Medicine 7(7): e1000316, 2010. https://www.rti.org/publication/social-relationships-mortality-risk-meta-analytic-review
- [22] Cohen, S. & Wills, T. A. Stress, social support, and the buffering hypothesis. Psychological Bulletin 98(2): 310–357, 1985. https://pubmed.ncbi.nlm.nih.gov/3901065/
- [23] Rickwood, D., Deane, F. P., Wilson, C. J. & Ciarrochi, J. Young people's help-seeking for mental health problems. Australian e-Journal for the Advancement of Mental Health 4(3), 2005. https://ro.uow.edu.au/hbspapers/2106/
- [24] Gulliver, A., Griffiths, K. M. & Christensen, H. Perceived barriers and facilitators to mental health help-seeking in young people: a systematic review. BMC Psychiatry 10: 113, 2010. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3022639/
- [25] Lucas, G. M., Gratch, J., King, A. & Morency, L.-P. It's only a computer: virtual humans increase willingness to disclose. Computers in Human Behavior 37: 94–100, 2014. https://ict.usc.edu/?p=9601
- [26] Lundahl, B. et al. A meta-analysis of motivational interviewing: twenty-five years of empirical studies. Research on Social Work Practice 20(2), 2010. https://digitalcommons.usu.edu/sswa_facpubs/199
- [27] Psychological First Aid training: a scoping review of its application, outcomes and implementation. 2021. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8123604/
- [28] The effectiveness and implementation of Psychological First Aid as a therapeutic intervention after trauma: an integrative review. 2024. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11370167/
- [29] Gollwitzer, P. M. & Sheeran, P. Implementation intentions and goal achievement: a meta-analysis of effects and processes. Advances in Experimental Social Psychology 38: 69–119, 2006.
- [30] Crockett, M. A. et al. Interventions to reduce mental health stigma in young people: a systematic review and meta-analysis. JAMA Network Open, 2025. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11736514/
- [31] Nazari, A. et al. The effect of web-based educational interventions on mental health literacy, stigma and help-seeking intentions/attitudes in young people: systematic review and meta-analysis. BMC Psychiatry, 2023. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10478184/
- [32] The impact of a messenger-based psychosocial chat counseling service on further help-seeking among children and young adults: longitudinal study. JMIR Mental Health 10: e43780, 2023. https://mental.jmir.org/2023/1/e43780/
- [33] Li, H. et al. Systematic review and meta-analysis of AI-based conversational agents for promoting mental health and well-being. npj Digital Medicine, 2023. https://doaj.org/article/f17df3045e7249698659f7fcaae4adad

Sources [21]–[33] were found and checked on 8 October 2026 from their abstracts and publisher pages; read the full text before quoting any figure that is not in this document.
