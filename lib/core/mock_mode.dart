// Per-feature switches to serve hardcoded data instead of hitting the real
// API. Flip a feature's flag to false once its endpoint(s) are confirmed
// wired up and tested against the real backend.
//
// Status (2026-07-21):
//   post-project      -> LIVE   (POST /api/projects)
//   my-projects       -> LIVE   (GET /api/projects/mine)
//   project-history   -> LIVE  (GET /api/projects/mine/history)
//   project-detail    -> LIVE   (GET /api/projects/{id})
//   bidders           -> LIVE   (GET /api/projects/{id}/bids, POST /api/projects/{id}/award)
//   bid-detail        -> LIVE   (GET /api/bids/{id})
//   home-dashboard    -> mock  (no backend endpoint yet)
//   guarantees        -> mock  (no backend endpoint yet)
//   guarantee-review  -> LIVE  (GET /api/projects/{id}/guarantee, POST /api/guarantees/{id}/approve|reject)
//   review-work       -> LIVE  (GET /api/projects/{id}/submitted-work, POST .../confirm-complete, POST .../flag-issue)
//   repost-project    -> LIVE  (GET /api/owner/projects/{id}/repost-draft, POST /api/owner/projects/{id}/repost)
//   leave-review      -> LIVE  (GET /api/owner/projects/{id}/review-context, POST /api/owner/projects/{id}/review)
//   company-reviews   -> LIVE  (GET /api/company-profile/reviews)
//   notifications     -> LIVE  (GET /api/notifications)
//   bidder-profile    -> LIVE   (GET /api/bids/{id}/company-profile)

const bool kUseMockPostProject = false;
const bool kUseMockMyProjects = false;
const bool kUseMockProjectHistory = false;
const bool kUseMockProjectDetail = false;
const bool kUseMockBidders = false;
const bool kUseMockBidDetail = false;
const bool kUseMockBidHistory = false; // GET /bids/mine/history — no backend endpoint yet
const bool kUseMockHomeDashboard = true;
const bool kUseMockGuarantees = true;
const bool kUseMockGuaranteeReview = false;
const bool kUseMockReviewWork = false;
const bool kUseMockRepostProject = false;
const bool kUseMockLeaveReview = false;
const bool kUseMockCompanyReviews = false;
const bool kUseMockNotifications = false;
const bool kUseMockBidderProfiles = false;
