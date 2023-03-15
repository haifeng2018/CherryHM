
/**
 * constant about refresh feature
 */
export class RefreshConstants {

  /**
   * refresh state tag
   */
  static readonly REFRESH_STATE_TAG = 'refresh_state_tag';

  /**
   * refresh default header height
   */
  static readonly REFRESH_HEADER_HEIGHT = 50;

  /**
   * refresh effective height
   */
  static readonly REFRESH_EFFECTIVE_HEIGHT = 1.2 * RefreshConstants.REFRESH_HEADER_HEIGHT;

  /**
   * refresh layout extra height
   */
  static readonly REFRESH_LAYOUT_EXTRA_HEIGHT = 0.1;

  /**
   * refresh header animation duration
   */
  static readonly REFRESH_HEADER_ANIM_DURATION = 440;
}

/**
 * refresh state enum
 */
export const RefreshState = {
  IDLE: 0,
  DRAGGING: 1,
  DRAGGING_REFRESHABLE: 2,
  REFRESHING: 3,
  COMPLETE: 4
}

/**
 * refresh header style enum
 */
export enum RefreshHeaderStyle {
  DEFAULT,
  CLOUD
}

