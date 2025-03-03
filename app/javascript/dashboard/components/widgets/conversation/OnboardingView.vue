<script>
import { mapGetters } from 'vuex';
import { useAccount } from 'dashboard/composables/useAccount';

export default {
  setup() {
    const { accountScopedUrl } = useAccount();
    return {
      accountScopedUrl,
    };
  },
  computed: {
    ...mapGetters({ globalConfig: 'globalConfig/get' }),
    newInboxURL() {
      return this.accountScopedUrl('settings/inboxes/new');
    },
    newAgentURL() {
      return this.accountScopedUrl('settings/agents/list');
    },
    newLabelsURL() {
      return this.accountScopedUrl('settings/labels/list');
    },
  },
};
</script>

<template>
  <div class="onboarding-wrap">
    <div class="onboarding">
      <div class="scroll-wrap">
        <div class="features-item">
          <h1 class="text-2xl text-slate-900 dark:text-slate-50">
            <span>{{
              $t('ONBOARDING.TITLE', {
                installationName: globalConfig.installationName,
              })
            }}</span>
          </h1>
          <p class="intro-body">
            {{
              $t('ONBOARDING.DESCRIPTION', {
                installationName: globalConfig.installationName,
              })
            }}
          </p>
          <p v-if="globalConfig.installationName === 'Chatwoot'">
            <a
              href="https://www.chatwoot.com/changelog"
              target="_blank"
              rel="noopener nofollow noreferrer"
              class="onboarding--link"
            >
              {{ $t('ONBOARDING.READ_LATEST_UPDATES') }}
            </a>
            <span>🎉</span>
          </p>
        </div>
        <div class="features-item">
          <h2 class="text-lg text-black-900 dark:text-slate-200">
            <span class="emoji">💬</span>
            <span class="conversation--title">{{
              $t('ONBOARDING.ALL_CONVERSATION.TITLE')
            }}</span>
          </h2>
          <p class="intro-body">
            {{ $t('ONBOARDING.ALL_CONVERSATION.DESCRIPTION') }}
          </p>
        </div>
        <div class="features-item">
          <h2 class="text-lg text-black-900 dark:text-slate-200">
            <span class="emoji">👥</span>
            {{ $t('ONBOARDING.TEAM_MEMBERS.TITLE') }}
          </h2>
          <p class="intro-body">
            {{ $t('ONBOARDING.TEAM_MEMBERS.DESCRIPTION') }}
          </p>
          <router-link :to="newAgentURL" class="onboarding--link">
            {{ $t('ONBOARDING.TEAM_MEMBERS.NEW_LINK') }}
          </router-link>
        </div>
        <div class="features-item">
          <h2 class="text-lg text-black-900 dark:text-slate-200">
            <span class="emoji">📥</span>{{ $t('ONBOARDING.INBOXES.TITLE') }}
          </h2>
          <p class="intro-body">
            {{ $t('ONBOARDING.INBOXES.DESCRIPTION') }}
          </p>
          <router-link :to="newInboxURL" class="onboarding--link">
            {{ $t('ONBOARDING.INBOXES.NEW_LINK') }}
          </router-link>
        </div>
        <div class="features-item">
          <h2 class="text-lg text-black-900 dark:text-slate-200">
            <span class="emoji">🔖</span>{{ $t('ONBOARDING.LABELS.TITLE') }}
          </h2>
          <p class="intro-body">
            {{ $t('ONBOARDING.LABELS.DESCRIPTION') }}
          </p>
          <router-link :to="newLabelsURL" class="onboarding--link">
            {{ $t('ONBOARDING.LABELS.NEW_LINK') }}
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.onboarding-wrap {
  display: flex;
  font-size: var(--font-size-small);
  justify-content: center;
  overflow: auto;
  text-align: left;
}
.onboarding {
  height: 100vh;
  overflow: auto;
}

.scroll-wrap {
  padding: var(--space-larger) 8.5rem;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.features-item {
  margin-bottom: var(--space-large);
}

.conversation--title {
  margin-left: var(--space-minus-smaller);
}

.page-title {
  font-size: var(--font-size-big);
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--space-one);
}

.block-title {
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--space-smaller);
  margin-left: var(--space-minus-large);
}

.intro-body {
  margin-bottom: var(--space-small);
  line-height: 1.5;
}

.onboarding--link {
  color: var(--w-500);
  font-weight: var(--font-weight-medium);
  text-decoration: underline;
}

.emoji {
  width: var(--space-large);
  display: inline-block;
}
</style>
