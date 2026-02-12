# Approved Dependencies Policy

> **Version:** 1.0.0  
> **Last Updated:** 2026-01-28  
> **Maintainer:** Platform Engineering Team  
> **Review Cadence:** Quarterly

This file defines the approved package dependencies for all components in the High Scores Demo application. The `Manage-Dependencies` agent uses this policy for enforcement.

---

## Policy Rules

1. **Only approved packages may be added** to the codebase
2. **Version ranges** must be respected; versions outside ranges require approval
3. **Blocklisted packages** are forbidden and will be rejected
4. **Security updates** are always permitted within approved version ranges
5. **Major version updates** require tech lead approval

---

## Frontend (npm)

### Runtime Dependencies

| Package | Approved Versions | Category | Notes |
|---------|-------------------|----------|-------|
| `react` | `^18.0.0` | Core | React framework |
| `react-dom` | `^18.0.0` | Core | React DOM renderer |
| `@emotion/react` | `^11.0.0` | Styling | CSS-in-JS |
| `@emotion/styled` | `^11.0.0` | Styling | Styled components |
| `@mui/material` | `^5.0.0`, `^6.0.0`, `^7.0.0` | UI | Material UI |
| `@mui/icons-material` | `^5.0.0`, `^6.0.0`, `^7.0.0` | UI | MUI Icons |
| `@radix-ui/*` | `*` | UI | Radix primitives (all packages) |
| `@popperjs/core` | `^2.0.0` | UI | Popper positioning |
| `class-variance-authority` | `^0.7.0` | Utility | CVA for variants |
| `clsx` | `^2.0.0` | Utility | Class name utility |
| `cmdk` | `^1.0.0` | UI | Command palette |
| `date-fns` | `^3.0.0` | Utility | Date manipulation |
| `embla-carousel-react` | `^8.0.0` | UI | Carousel |
| `input-otp` | `^1.0.0` | UI | OTP input |
| `lucide-react` | `^0.400.0` | UI | Icons |
| `motion` | `^12.0.0` | Animation | Motion animations |
| `next-themes` | `^0.4.0` | Utility | Theme switching |
| `react-day-picker` | `^8.0.0` | UI | Date picker |
| `react-dnd` | `^16.0.0` | UI | Drag and drop |
| `react-dnd-html5-backend` | `^16.0.0` | UI | DnD HTML5 backend |
| `react-hook-form` | `^7.0.0` | Forms | Form management |
| `react-popper` | `^2.0.0` | UI | Popper wrapper |
| `react-resizable-panels` | `^2.0.0` | UI | Resizable panels |
| `react-responsive-masonry` | `^2.0.0` | UI | Masonry layout |
| `react-slick` | `^0.30.0`, `^0.31.0` | UI | Slick carousel |
| `recharts` | `^2.0.0` | Charts | Charting library |
| `sonner` | `^2.0.0` | UI | Toast notifications |
| `tailwind-merge` | `^3.0.0` | Utility | Tailwind class merge |
| `tw-animate-css` | `^1.0.0` | Animation | Tailwind animations |
| `vaul` | `^1.0.0` | UI | Drawer component |

### Dev Dependencies

| Package | Approved Versions | Category | Notes |
|---------|-------------------|----------|-------|
| `typescript` | `^5.0.0` | Language | Type checking |
| `vite` | `^5.0.0`, `^6.0.0` | Build | Build tool |
| `@vitejs/plugin-react` | `^4.0.0` | Build | Vite React plugin |
| `tailwindcss` | `^3.0.0`, `^4.0.0` | Styling | CSS framework |
| `@tailwindcss/vite` | `^4.0.0` | Build | Tailwind Vite plugin |
| `@types/react` | `^18.0.0` | Types | React types |
| `@types/react-dom` | `^18.0.0` | Types | React DOM types |
| `eslint` | `^8.0.0`, `^9.0.0` | Linting | Code linting |
| `prettier` | `^3.0.0` | Formatting | Code formatting |

---

## Java Backend (Gradle)

### Plugins

| Plugin | Approved Versions | Notes |
|--------|-------------------|-------|
| `org.springframework.boot` | `3.2.*`, `3.3.*`, `3.4.*`, `3.5.*` | Spring Boot |
| `io.spring.dependency-management` | `1.1.*` | Dependency management |

### Runtime Dependencies

| Dependency | Approved Versions | Notes |
|------------|-------------------|-------|
| `org.springframework.boot:spring-boot-starter` | (managed) | Core starter |
| `org.springframework.boot:spring-boot-starter-web` | (managed) | Web starter |
| `org.springframework.boot:spring-boot-starter-data-jpa` | (managed) | JPA starter |
| `org.springframework.boot:spring-boot-starter-validation` | (managed) | Validation |
| `org.springframework.boot:spring-boot-starter-actuator` | (managed) | Actuator |
| `org.postgresql:postgresql` | `42.*` | PostgreSQL driver |
| `com.h2database:h2` | `2.*` | H2 database (dev only) |
| `org.projectlombok:lombok` | `1.18.*` | Lombok |

### Test Dependencies

| Dependency | Approved Versions | Notes |
|------------|-------------------|-------|
| `org.springframework.boot:spring-boot-starter-test` | (managed) | Test starter |
| `org.junit.platform:junit-platform-launcher` | (managed) | JUnit launcher |

---

## Go Backend (Go Modules)

### Runtime Dependencies

| Module | Approved Versions | Notes |
|--------|-------------------|-------|
| `github.com/gin-gonic/gin` | `v1.9.*`, `v1.10.*` | HTTP framework |
| `github.com/gin-contrib/cors` | `v1.5.*`, `v1.6.*` | CORS middleware |
| `github.com/google/uuid` | `v1.4.*`, `v1.5.*`, `v1.6.*` | UUID generation |
| `github.com/gorilla/websocket` | `v1.5.*` | WebSocket |
| `gorm.io/gorm` | `v1.25.*` | ORM |
| `gorm.io/driver/sqlite` | `v1.5.*` | SQLite driver |
| `gorm.io/driver/postgres` | `v1.5.*` | PostgreSQL driver |

### Test Dependencies

| Module | Approved Versions | Notes |
|--------|-------------------|-------|
| `github.com/stretchr/testify` | `v1.8.*`, `v1.9.*` | Test assertions |

---

## Blocklist (Forbidden Packages)

### Frontend

| Package | Reason | Alternative |
|---------|--------|-------------|
| `moment` | Large bundle size, deprecated | `date-fns` |
| `lodash` | No tree-shaking | `lodash-es` or native JS |
| `jquery` | Not needed with React | Native React |
| `node-sass` | Deprecated | `sass` |
| `request` | Deprecated | `node-fetch` or `axios` |
| `left-pad` | Security incident history | Native `String.padStart()` |

### Java Backend

| Package | Reason | Alternative |
|---------|--------|-------------|
| `commons-collections:commons-collections` | CVE-2015-6420 | `org.apache.commons:commons-collections4` |
| `log4j:log4j` | CVE-2021-44228 | `org.apache.logging.log4j:log4j-core@2.17+` |
| `com.google.code.gson:gson` < 2.8.9 | CVE-2022-25647 | `com.google.code.gson:gson@2.10+` |

### Go Backend

| Module | Reason | Alternative |
|--------|--------|-------------|
| `github.com/dgrijalva/jwt-go` | Unmaintained, CVEs | `github.com/golang-jwt/jwt/v5` |
| `github.com/ugorji/go` | Unmaintained | `github.com/ugorji/go/codec` |

---

## Approval Process

### Adding New Dependencies

1. **Developer** requests addition via PR description or Slack
2. **Security scan** is performed automatically
3. **Tech Lead** reviews:
   - Is it necessary?
   - Is it actively maintained?
   - What's the bundle/binary size impact?
   - Are there security vulnerabilities?
4. **Platform Team** adds to approved list if approved
5. **Developer** can now add the dependency

### Requesting Version Updates

1. **Minor/Patch updates** within approved range: Self-service
2. **Major updates** or outside approved range:
   - Submit request with changelog review
   - Document breaking changes
   - Tech Lead approval required

### Emergency Security Updates

1. **Critical CVEs**: Immediate update permitted, document after
2. **High CVEs**: Fast-track approval (24h)
3. **Medium/Low CVEs**: Normal approval process

---

## Review Schedule

| Review Type | Frequency | Owner |
|-------------|-----------|-------|
| Security CVE scan | Weekly (automated) | CI/CD |
| Outdated packages | Monthly | Dev Team |
| Policy review | Quarterly | Platform Team |
| Major version evaluation | As released | Tech Lead |

---

## Changelog

### v1.0.0 (2026-01-28)
- Initial approved dependencies list
- Blocklist established
- Approval process documented
