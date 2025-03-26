export const MemberRole = {
	ADMIN: "admin",
	STAFF: "staff",
};

export type MemberRoleType = (typeof MemberRole)[keyof typeof MemberRole];
