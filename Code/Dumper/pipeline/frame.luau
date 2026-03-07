--!nocheck
--!nolint

_P = {
	genDate = __COMPOSER.Insert(__COMPOSER.genDate),
	cfg = __COMPOSER.Insert(__COMPOSER.cfg),
	vers = __COMPOSER.Insert(__COMPOSER.vers),
}

__COMPOSER.Insert(__COMPOSER.build)
