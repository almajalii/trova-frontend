// Per-feature switches to serve hardcoded data instead of hitting the real
// API. Flip a feature's flag to false once its endpoint(s) are confirmed
// wired up and tested against the real backend.
//
// Status (2026-07-21):
//   post-project      -> LIVE   (POST /api/projects)
//   my-projects       -> LIVE   (GET /api/projects/mine)
//   project-history   -> mock  (GET /api/projects/mine/history)
//   project-detail    -> LIVE   (GET /api/projects/{id})
//   bidders           -> LIVE   (GET /api/projects/{id}/bids, POST /api/projects/{id}/award)
//   home-dashboard    -> mock  (no backend endpoint yet)
//   guarantees        -> mock  (no backend endpoint yet)
//   guarantee-review  -> mock  (no backend endpoint yet)
//   review-work       -> mock  (no backend endpoint yet)
//   repost-project    -> mock  (no backend endpoint yet)
//   leave-review      -> mock  (no backend endpoint yet)

const bool kUseMockPostProject = false;

const bool kUseMockMyProjects = false;
const bool kUseMockProjectHistory = true;
const bool kUseMockProjectDetail = false;
const bool kUseMockBidders = false;
const bool kUseMockHomeDashboard = true;
const bool kUseMockGuarantees = true;
const bool kUseMockGuaranteeReview = true;
const bool kUseMockReviewWork = true;
const bool kUseMockRepostProject = true;
const bool kUseMockLeaveReview = true;
